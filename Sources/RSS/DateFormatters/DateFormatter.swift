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

class ISO8601DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
    override var dateFormats: [String] {
        [
            "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm",
        ]
    }

    override var backupDateFormats: [String] {
        [
            "yyyy-MM-dd'T'HH:mmSSZZZZZ"
        ]
    }
}

// MARK: - RFC3339 formatter
class RFC3339DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
    override var dateFormats: [String] {
        [
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
        ]
    }

    override var backupDateFormats: [String] {
        [
            "yyyy-MM-dd'T'HH:mm:ss-SS:ZZ",
            "yyyy-MM-dd'T'HH:mm:ss",
        ]
    }
}

// MARK: - RFC822 formatter
class RFC822DateFormatter: PermissiveDateFormatter, @unchecked Sendable {
    override var dateFormats: [String] {
        [
            "EEE, d MMM yyyy HH:mm:ss zzz",
            "EEE, d MMM yyyy HH:mm zzz",
            "d MMM yyyy HH:mm:ss Z",
            "yyyy-MM-dd HH:mm:ss Z",
        ]
    }

    override var backupDateFormats: [String] {
        [
            "d MMM yyyy HH:mm:ss zzz",
            "d MMM yyyy HH:mm zzz",
            "EEE, dd MMM yyyy, HH:mm:ss zzz",
        ]
    }

    override func date(from string: String) -> Date? {
        if let date = super.date(from: string) {
            return date
        }

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

enum DateSpec {
    case iso8601
    case rfc3339
    case rfc822
    case permissive
}

// MARK: - FeedDateFormatter

class FeedDateFormatter: DateFormatter, @unchecked Sendable {
    let spec: DateSpec

    init(spec: DateSpec) {
        self.spec = spec
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var iso8601Formatter: ISO8601DateFormatter = {
        ISO8601DateFormatter()
    }()

    lazy var rfc3339Formatter: RFC3339DateFormatter = {
        RFC3339DateFormatter()
    }()

    lazy var rfc822Formatter: RFC822DateFormatter = {
        RFC822DateFormatter()
    }()

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
