import Foundation

public struct RSSFeedItem {

    public var title: String?
    public var link: String?
    public var description: String?
    public var author: String?
    public var categories: [RSSFeedCategory]?
    public var comments: String?
    public var enclosure: RSSFeedEnclosure?
    public var guid: String?
    public var pubDate: Date?

    public init(
        title: String? = nil,
        link: String? = nil,
        description: String? = nil,
        author: String? = nil,
        categories: [RSSFeedCategory]? = nil,
        comments: String? = nil,
        enclosure: RSSFeedEnclosure? = nil,
        guid: String? = nil,
        pubDate: Date? = nil
    ) {
        self.title = title
        self.link = link
        self.description = description
        self.author = author
        self.categories = categories
        self.comments = comments
        self.enclosure = enclosure
        self.guid = guid
        self.pubDate = pubDate
    }
}

// MARK: - Equatable

extension RSSFeedItem: Equatable {}

// MARK: - Hashable

extension RSSFeedItem: Hashable {}

// MARK: - Codable

extension RSSFeedItem: Codable {
    private enum CodingKeys: CodingKey {
        case title
        case link
        case description
        case author
        case category
        case comments
        case enclosure
        case guid
        case pubDate
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<RSSFeedItem.CodingKeys> = try decoder.container(keyedBy: RSSFeedItem.CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: RSSFeedItem.CodingKeys.title)
        link = try container.decodeIfPresent(String.self, forKey: RSSFeedItem.CodingKeys.link)
        description = try container.decodeIfPresent(String.self, forKey: RSSFeedItem.CodingKeys.description)
        author = try container.decodeIfPresent(String.self, forKey: RSSFeedItem.CodingKeys.author)
        categories = try container.decodeIfPresent([RSSFeedCategory].self, forKey: RSSFeedItem.CodingKeys.category)
        comments = try container.decodeIfPresent(String.self, forKey: RSSFeedItem.CodingKeys.comments)
        enclosure = try container.decodeIfPresent(RSSFeedEnclosure.self, forKey: RSSFeedItem.CodingKeys.enclosure)
        guid = try container.decodeIfPresent(String.self, forKey: RSSFeedItem.CodingKeys.guid)
        pubDate = try container.decodeIfPresent(Date.self, forKey: RSSFeedItem.CodingKeys.pubDate)
    }

    public func encode(to encoder: any Encoder) throws {
        var container: KeyedEncodingContainer<RSSFeedItem.CodingKeys> = encoder.container(keyedBy: RSSFeedItem.CodingKeys.self)

        try container.encodeIfPresent(title, forKey: RSSFeedItem.CodingKeys.title)
        try container.encodeIfPresent(link, forKey: RSSFeedItem.CodingKeys.link)
        try container.encodeIfPresent(description, forKey: RSSFeedItem.CodingKeys.description)
        try container.encodeIfPresent(author, forKey: RSSFeedItem.CodingKeys.author)
        try container.encodeIfPresent(categories, forKey: RSSFeedItem.CodingKeys.category)
        try container.encodeIfPresent(comments, forKey: RSSFeedItem.CodingKeys.comments)
        try container.encodeIfPresent(enclosure, forKey: RSSFeedItem.CodingKeys.enclosure)
        try container.encodeIfPresent(guid, forKey: RSSFeedItem.CodingKeys.guid)
        try container.encodeIfPresent(pubDate, forKey: RSSFeedItem.CodingKeys.pubDate)
    }
}
