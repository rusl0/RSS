import Foundation

public struct RSSFeedEnclosure {
    public var url: String?
    public var type: String?

    public init(url: String? = nil, type: String? = nil) {
        self.url = url
        self.type = type
    }
}
