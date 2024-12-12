import Foundation

public struct RSSFeedEnclosure: Codable, Equatable, Hashable {
    public var url: String?
    public var length: Int64?
    public var type: String?

    public init(url: String? = nil, length: Int64? = nil, type: String? = nil) {
        self.url = url
        self.length = length
        self.type = type
    }
}