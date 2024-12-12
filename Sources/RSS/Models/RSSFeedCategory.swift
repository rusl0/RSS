import Foundation

public struct RSSFeedCategoryAttributes: Codable, Equatable, Hashable {
    public var domain: String?

    public init(domain: String? = nil) {
        self.domain = domain
    }
}

public typealias RSSFeedCategory = RSSFeedAttributesElement<RSSFeedCategoryAttributes>
