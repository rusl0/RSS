import Foundation

public struct RSSFeedImage {
    public var url: String?
    public var title: String?
    public var link: String?
    public var width: Int?
    public var height: Int?
    public var description: String?

    public init(url: String? = nil, title: String? = nil, link: String? = nil, width: Int? = nil, height: Int? = nil, description: String? = nil) {
        self.url = url
        self.title = title
        self.link = link
        self.width = width
        self.height = height
        self.description = description
    }
}

// MARK: - Equatable

extension RSSFeedImage: Equatable {}

// MARK: - Hashable

extension RSSFeedImage: Hashable {}

// MARK: - Codable

extension RSSFeedImage: Decodable {
    private enum CodingKeys: CodingKey {
        case url
        case title
        case link
        case width
        case height
        case description
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<RSSFeedImage.CodingKeys> = try decoder.container(keyedBy: RSSFeedImage.CodingKeys.self)

        url = try container.decodeIfPresent(String.self, forKey: RSSFeedImage.CodingKeys.url)
        title = try container.decodeIfPresent(String.self, forKey: RSSFeedImage.CodingKeys.title)
        link = try container.decodeIfPresent(String.self, forKey: RSSFeedImage.CodingKeys.link)
        width = try container.decodeIfPresent(Int.self, forKey: RSSFeedImage.CodingKeys.width)
        height = try container.decodeIfPresent(Int.self, forKey: RSSFeedImage.CodingKeys.height)
        description = try container.decodeIfPresent(String.self, forKey: RSSFeedImage.CodingKeys.description)
    }
}
