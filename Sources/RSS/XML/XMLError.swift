import Foundation

public enum XMLError: Error {
    case notFound
    case cdataDecoding(element: String)
    case invalidUrl
    case invalidUrlString
    case network(reason: String)
    case unexpected(reason: String)
}

// MARK: - LocalizedError

extension XMLError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "Feed not found."
        case .cdataDecoding:
            return "Error decoding CDATA Block."
        case .invalidUrl:
            return "Invalid URL provided."
        case .invalidUrlString:
            return "Malformed URL string."
        case let .network(reason):
            return "Network error: \(reason)."
        case let .unexpected(reason):
            return "Internal error: \(reason)."
        }
    }

    public var failureReason: String? {
        switch self {
        case .notFound:
            return "No recognizable feed was found in the parsed data."
        case let .cdataDecoding(element):
            return "Failed to decode CDATA block to Unicode at element: \(element). Ensure the data is in UTF-8 format."
        case .invalidUrl:
            return "The provided URL could not be parsed or recognized."
        case .invalidUrlString:
            return "The URL string format is incorrect or incomplete."
        case let .network(reason):
            return "A network-related issue interrupted the process: \(reason)"
        case let .unexpected(reason):
            return "An internal error occurred that could not be resolved: \(reason)"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .notFound:
            return "Please provide a valid RSS, Atom, or JSON feed."
        case .cdataDecoding:
            return "Verify that CDATA blocks are UTF-8 encoded."
        case .invalidUrl:
            return "Ensure that a complete, well-formed URL is provided."
        case .invalidUrlString:
            return "Check that the URL string is correctly formatted and contains necessary components."
        case let .network(reason):
            return "Inspect network connection settings or retry later: \(reason)"
        case .unexpected:
            return "Consider submitting a detailed issue report on GitHub for assistance."
        }
    }
}

// MARK: - CustomNSError

extension XMLError: CustomNSError {
    public var errorCode: Int {
        switch self {
        case .notFound: return -1000
        case .cdataDecoding: return -10001
        case .invalidUrl: return -10002
        case .invalidUrlString: return -10003
        case .network: return -10004
        case .unexpected: return -90000
        }
    }

    public var errorUserInfo: [String: Any] {
        return [
            NSLocalizedDescriptionKey: errorDescription ?? "",
            NSLocalizedFailureReasonErrorKey: failureReason ?? "",
            NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? "",
        ]
    }

    public static var errorDomain: String {
        return "com.feedkit.error"
    }

    public var error: NSError {
        return NSError(
            domain: XMLError.errorDomain,
            code: errorCode,
            userInfo: errorUserInfo
        )
    }
}
