import Foundation

public struct RSSFeedCategory: Codable, Equatable, Hashable {
    public var text: String?

    public init(text: String? = nil) {
        self.text = text
    }
}
