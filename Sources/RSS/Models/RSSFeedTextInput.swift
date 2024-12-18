import Foundation

public struct RSSFeedTextInput {
    public var title: String?
    public var description: String?
    public var name: String?
    public var link: String?

    public init(title: String? = nil, description: String? = nil, name: String? = nil, link: String? = nil) {
        self.title = title
        self.description = description
        self.name = name
        self.link = link
    }
}

// MARK: - Equatable

extension RSSFeedTextInput: Equatable {}

// MARK: - Hashable

extension RSSFeedTextInput: Hashable {}

// MARK: - Codable

extension RSSFeedTextInput: Decodable {
    private enum CodingKeys: CodingKey {
        case title
        case description
        case name
        case link
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<RSSFeedTextInput.CodingKeys> = try decoder.container(keyedBy: RSSFeedTextInput.CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: RSSFeedTextInput.CodingKeys.title)
        description = try container.decodeIfPresent(String.self, forKey: RSSFeedTextInput.CodingKeys.description)
        name = try container.decodeIfPresent(String.self, forKey: RSSFeedTextInput.CodingKeys.name)
        link = try container.decodeIfPresent(String.self, forKey: RSSFeedTextInput.CodingKeys.link)
    }
}
