import Foundation

public enum RSSXMLError: Error {
    case notFound
    case cdataDecoding(element: String)
    case invalidURL
    case invalidUrlString
    case network(reason: String)
    case unexpected(reason: String)
}

extension RSSXMLError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "Feed not found."
        case .cdataDecoding:
            return "Error decoding CDATA Block."
        case .invalidURL:
            return "Invalid URL provided."
        case .invalidUrlString:
            return "Malforfed URL string."
        case let .network(reason):
            return "Network error: \(reason)."
        case let .unexpected(reason):
            return "Internal error: \(reason)."
        }
    }
}
