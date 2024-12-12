import Foundation

class PermissiveDateFormatter: DateFormatter, @unchecked Sendable {

    var dateFormats: [String] { [] }
    var backupDateFormats: [String] { [] }

    override init() {
        super.init()
        timeZone = TimeZone(secondsFromGMT: 0)
        locale = Locale(identifier: "en_US_POSIX")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    override func date(from string: String) -> Date? {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        for format in dateFormats + backupDateFormats {
            dateFormat = format
            if let date = super.date(from: trimmedString) {
                return date
            }
        }
        return nil
    }

    override func string(from date: Date) -> String {
        for format in dateFormats {
            dateFormat = format
            let string = super.string(from: date)
            if !string.isEmpty {
                return string
            }
        }
        return ""
    }
}

// MARK: - ISO8601 formatter

/// Formatter for ISO8601 date specification.
class ISO8601DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
    /// List of date formats supported for ISO8601.
    override var dateFormats: [String] {
        [
            "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm",
        ]
    }

    override var backupDateFormats: [String] {
        [
            // Not fully compatible with ISO8601.
            // The correct ISO8601 format would separate the seconds (SS) from the timezone
            // offset (ZZZZZ) with a colon or period.
            "yyyy-MM-dd'T'HH:mmSSZZZZZ"
        ]
    }
}

// MARK: - RFC3339 formatter

/// Formatter for RFC3339 date specification.
class RFC3339DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
    /// List of date formats supported for RFC3339.
    override var dateFormats: [String] {
        [
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
        ]
    }

    override var backupDateFormats: [String] {
        [
            // Not fully compatible with RFC3339 (incorrect timezone format).
            "yyyy-MM-dd'T'HH:mm:ss-SS:ZZ",
            // Not fully compatible with RFC3339 (missing timezone information).
            "yyyy-MM-dd'T'HH:mm:ss",
        ]
    }
}

// MARK: - RFC822 formatter

/// Formatter for RFC822 date specification with backup formats.
class RFC822DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
    /// List of date formats supported for RFC822.
    override var dateFormats: [String] {
        [
            "EEE, d MMM yyyy HH:mm:ss zzz",
            "EEE, d MMM yyyy HH:mm zzz",
            "d MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd HH:mm:ss Z",
        ]
    }

    /// Backup date formats to handle potential parsing issues.
    override var backupDateFormats: [String] {
        [
            "d MMM yyyy HH:mm:ss zzz",
            "d MMM yyyy HH:mm zzz",
            "EEE, dd MMM yyyy, HH:mm:ss zzz",
        ]
    }

    /// Attempts to parse a string into a Date using primary and backup formats.
    override func date(from string: String) -> Date? {
        if let date = super.date(from: string) {
            return date
        }

        // Attempt to remove weekday prefix (e.g., "Tues") for compatibility.
        // See if we can lop off a text weekday, as DateFormatter does not
        // handle these in full compliance with Unicode tr35-31. For example,
        // "Tues, 6 November 2007 12:00:00 GMT" is rejected because of the "Tues",
        // even though "Tues" is used as an example for EEE in tr35-31.
        let trimRegEx = try! NSRegularExpression(pattern: "^[a-zA-Z]+, ([\\w :+-]+)$")
        let trimmed = trimRegEx.stringByReplacingMatches(
            in: string,
            options: [],
            range: NSMakeRange(0, string.count),
            withTemplate: "$1"
        )

        for format in backupDateFormats {
            dateFormat = format
            if let date = super.date(from: trimmed) {
                return date
            }
        }
        return nil
    }
}

// MARK: - DateSpec

/// Enum representing different date specifications.
enum DateSpec {
    /// ISO8601 date format (e.g., 2024-12-05T10:30:00Z).
    case iso8601
    /// RFC3339 date format (e.g., 2024-12-05T10:30:00+00:00).
    case rfc3339
    /// RFC822 date format (e.g., Tue, 05 Dec 2024 10:30:00 GMT).
    case rfc822
    /// Permissive mode which attempts to parse the date using multiple formats.
    /// It tries RFC822 first, then RFC3339, and finally ISO8601 in that order.
    case permissive
}

// MARK: - FeedDateFormatter

/// A formatter that handles multiple date specifications (ISO8601, RFC3339, RFC822).
class FeedDateFormatter: DateFormatter, @unchecked Sendable {
    /// The date specification to use for formatting dates.
    let spec: DateSpec

    /// Initializes the date formatter with a specified date format.
    ///
    /// - Parameter spec: The date specification (ISO8601, RFC3339, RFC822, etc.).
    init(spec: DateSpec) {
        self.spec = spec
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// ISO8601 date formatter.
    lazy var iso8601Formatter: ISO8601DateFormatter = {
        ISO8601DateFormatter()
    }()

    /// RFC3339 date formatter.
    lazy var rfc3339Formatter: RFC3339DateFormatter = {
        RFC3339DateFormatter()
    }()

    /// RFC822 date formatter.
    lazy var rfc822Formatter: RFC822DateFormatter = {
        RFC822DateFormatter()
    }()

    /// Converts a string to a Date based on the given date specification.
    ///
    /// - Parameters:
    ///   - string: The date string to be parsed.
    /// - Returns: A Date object if parsing is successful, otherwise nil.
    override func date(from string: String) -> Date? {
        switch spec {
        case .iso8601:
            return iso8601Formatter.date(from: string)
        case .rfc3339:
            return rfc3339Formatter.date(from: string)
        case .rfc822:
            return rfc822Formatter.date(from: string)
        case .permissive:
            return
                rfc822Formatter.date(from: string) ?? rfc3339Formatter.date(from: string) ?? iso8601Formatter.date(from: string)
        }
    }

    /// Converts a Date to a string based on the given date specification.
    ///
    /// - Parameters:
    ///   - date: The Date object to be converted to a string.
    /// - Returns: A string representation of the date.
    override func string(from date: Date) -> String {
        switch spec {
        case .iso8601:
            return iso8601Formatter.string(from: date)
        case .rfc3339:
            return rfc3339Formatter.string(from: date)
        case .rfc822:
            return rfc822Formatter.string(from: date)
        case .permissive:
            fatalError()
        }
    }
}
