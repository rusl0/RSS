import Foundation

public struct RSSFeedItem {
    public var title: String?
    public var link: String?
    public var description: String?
    public var author: String?
    public var enclosure: [RSSFeedEnclosure]?
    public var guid: String?
    public var pubDate: Date?

    public init(
        title: String? = nil,
        link: String? = nil,
        description: String? = nil,
        author: String? = nil,
        enclosure: [RSSFeedEnclosure]? = nil,
        guid: String? = nil,
        pubDate: Date? = nil
    ) {
        self.title = title
        self.link = link
        self.description = description
        self.author = author
        self.enclosure = enclosure
        self.guid = guid
        self.pubDate = pubDate
    }
}
