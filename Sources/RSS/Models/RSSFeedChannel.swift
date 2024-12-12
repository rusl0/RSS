import Foundation

public struct RSSFeedChannel {
    public var title: String?
    public var link: String?
    public var description: String?
    public var language: String?
    public var copyright: String?
    public var managingEditor: String?
    public var webMaster: String?
    public var pubDate: Date?
    public var lastBuildDate: Date?
    public var categories: [RSSFeedCategory]?
    public var generator: String?
    public var docs: String?
    public var rating: String?
    public var ttl: Int?
    public var image: RSSFeedImage?
    public var textInput: RSSFeedTextInput?
    public var skipHours: RSSFeedSkipHours?
    public var skipDays: RSSFeedSkipDays?
    public var items: [RSSFeedItem]?

    public init(
        title: String? = nil,
        link: String? = nil,
        description: String? = nil,
        language: String? = nil,
        copyright: String? = nil,
        managingEditor: String? = nil,
        webMaster: String? = nil,
        pubDate: Date? = nil,
        lastBuildDate: Date? = nil,
        categories: [RSSFeedCategory]? = nil,
        generator: String? = nil,
        docs: String? = nil,
        rating: String? = nil,
        ttl: Int? = nil,
        image: RSSFeedImage? = nil,
        textInput: RSSFeedTextInput? = nil,
        skipHours: RSSFeedSkipHours? = nil,
        skipDays: RSSFeedSkipDays? = nil,
        items: [RSSFeedItem]? = nil
    ) {
        self.title = title
        self.link = link
        self.description = description
        self.language = language
        self.copyright = copyright
        self.managingEditor = managingEditor
        self.webMaster = webMaster
        self.pubDate = pubDate
        self.lastBuildDate = lastBuildDate
        self.categories = categories
        self.generator = generator
        self.docs = docs
        self.rating = rating
        self.ttl = ttl
        self.image = image
        self.textInput = textInput
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
        case managingEditor
        case webMaster
        case pubDate
        case lastBuildDate
        case category
        case generator
        case docs
        case rating
        case ttl
        case image
        case textInput
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
        managingEditor = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.managingEditor)
        webMaster = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.webMaster)
        pubDate = try container.decodeIfPresent(Date.self, forKey: RSSFeedChannel.CodingKeys.pubDate)
        lastBuildDate = try container.decodeIfPresent(Date.self, forKey: RSSFeedChannel.CodingKeys.lastBuildDate)
        categories = try container.decodeIfPresent([RSSFeedCategory].self, forKey: RSSFeedChannel.CodingKeys.category)
        generator = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.generator)
        docs = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.docs)
        rating = try container.decodeIfPresent(String.self, forKey: RSSFeedChannel.CodingKeys.rating)
        ttl = try container.decodeIfPresent(Int.self, forKey: RSSFeedChannel.CodingKeys.ttl)
        image = try container.decodeIfPresent(RSSFeedImage.self, forKey: RSSFeedChannel.CodingKeys.image)
        textInput = try container.decodeIfPresent(RSSFeedTextInput.self, forKey: RSSFeedChannel.CodingKeys.textInput)
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
        try container.encodeIfPresent(managingEditor, forKey: RSSFeedChannel.CodingKeys.managingEditor)
        try container.encodeIfPresent(webMaster, forKey: RSSFeedChannel.CodingKeys.webMaster)
        try container.encodeIfPresent(pubDate, forKey: RSSFeedChannel.CodingKeys.pubDate)
        try container.encodeIfPresent(lastBuildDate, forKey: RSSFeedChannel.CodingKeys.lastBuildDate)
        try container.encodeIfPresent(categories, forKey: RSSFeedChannel.CodingKeys.category)
        try container.encodeIfPresent(generator, forKey: RSSFeedChannel.CodingKeys.generator)
        try container.encodeIfPresent(docs, forKey: RSSFeedChannel.CodingKeys.docs)
        try container.encodeIfPresent(rating, forKey: RSSFeedChannel.CodingKeys.rating)
        try container.encodeIfPresent(ttl, forKey: RSSFeedChannel.CodingKeys.ttl)
        try container.encodeIfPresent(image, forKey: RSSFeedChannel.CodingKeys.image)
        try container.encodeIfPresent(textInput, forKey: RSSFeedChannel.CodingKeys.textInput)
        try container.encodeIfPresent(skipHours, forKey: RSSFeedChannel.CodingKeys.skipHours)
        try container.encodeIfPresent(skipDays, forKey: RSSFeedChannel.CodingKeys.skipDays)
        try container.encodeIfPresent(items, forKey: RSSFeedChannel.CodingKeys.item)
    }
}
