import Foundation

public struct RSSFeedChannel {
    public var title: String?
    public var link: String?
    public var description: String?
    public var language: String?
    public var copyright: String?
    public var pubDate: Date?
    public var lastBuildDate: Date?
    public var categories: [RSSFeedCategory]?
    public var image: RSSFeedImage?
    public var skipHours: RSSFeedSkipHours?
    public var skipDays: RSSFeedSkipDays?
    public var items: [RSSFeedItem]?

    public init(
        title: String? = nil,
        link: String? = nil,
        description: String? = nil,
        language: String? = nil,
        copyright: String? = nil,
        pubDate: Date? = nil,
        lastBuildDate: Date? = nil,
        categories: [RSSFeedCategory]? = nil,
        image: RSSFeedImage? = nil,
        skipHours: RSSFeedSkipHours? = nil,
        skipDays: RSSFeedSkipDays? = nil,
        items: [RSSFeedItem]? = nil
    ) {
        self.title = title
        self.link = link
        self.description = description
        self.language = language
        self.copyright = copyright
        self.pubDate = pubDate
        self.lastBuildDate = lastBuildDate
        self.categories = categories
        self.image = image
        self.skipHours = skipHours
        self.skipDays = skipDays
        self.items = items
    }
}

// MARK: - Equatable

extension RSSFeedChannel: Equatable {}

// MARK: - Hashable

extension RSSFeedChannel: Hashable {}

// MARK: - Codable

extension RSSFeedChannel: Codable {
    private enum CodingKeys: CodingKey {
        case title
        case link
        case description
        case language
        case copyright
        case pubDate
        case lastBuildDate
        case category
        case image
        case skipHours
        case skipDays
        case item
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<RSSFeedChannel.CodingKeys> = try decoder.container(keyedBy: RSSFeedChannel.CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.title)
        link = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.link)
        description = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.description)
        language = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.language)
        copyright = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.copyright)
        pubDate = try container.decodeIfPresent(Date.self, forKey: RSSFeedChannel.CodingKeys.pubDate)
        lastBuildDate = try container.decodeIfPresent(Date.self, forKey: RSSFeedChannel.CodingKeys.lastBuildDate)
        categories = try container.decodeIfPresent([RSSFeedCategory].self, forKey: RSSFeedChannel.CodingKeys.category)
        image = try container.decodeIfPresent(RSSFeedImage.self, forKey: RSSFeedChannel.CodingKeys.image)
        skipHours = try container.decodeIfPresent(RSSFeedSkipHours.self, forKey: RSSFeedChannel.CodingKeys.skipHours)
        skipDays = try container.decodeIfPresent(RSSFeedSkipDays.self, forKey: RSSFeedChannel.CodingKeys.skipDays)
        items = try container.decodeIfPresent([RSSFeedItem].self, forKey: RSSFeedChannel.CodingKeys.item)
    }

    public func encode(to encoder: any Encoder) throws {
        var container: KeyedEncodingContainer<RSSFeedChannel.CodingKeys> = encoder.container(keyedBy: RSSFeedChannel.CodingKeys.self)

        try container.encodeIfPresent(title, forKey: RSSFeedChannel.CodingKeys.title)
        try container.encodeIfPresent(link, forKey: RSSFeedChannel.CodingKeys.link)
        try container.encodeIfPresent(description, forKey: RSSFeedChannel.CodingKeys.description)
        try container.encodeIfPresent(language, forKey: RSSFeedChannel.CodingKeys.language)
        try container.encodeIfPresent(copyright, forKey: RSSFeedChannel.CodingKeys.copyright)
        try container.encodeIfPresent(pubDate, forKey: RSSFeedChannel.CodingKeys.pubDate)
        try container.encodeIfPresent(lastBuildDate, forKey: RSSFeedChannel.CodingKeys.lastBuildDate)
        try container.encodeIfPresent(categories, forKey: RSSFeedChannel.CodingKeys.category)
        try container.encodeIfPresent(image, forKey: RSSFeedChannel.CodingKeys.image)
        try container.encodeIfPresent(skipHours, forKey: RSSFeedChannel.CodingKeys.skipHours)
        try container.encodeIfPresent(skipDays, forKey: RSSFeedChannel.CodingKeys.skipDays)
        try container.encodeIfPresent(items, forKey: RSSFeedChannel.CodingKeys.item)
    }
}
