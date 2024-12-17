import Foundation

public struct RSSFeedElement<Attributes: Decodable & Equatable & Hashable>: Decodable, Equatable, Hashable {
    public var text: String?
    public var attributes: Attributes?

    public init(text: String? = nil, attributes: Attributes? = nil) {
        self.text = text
        self.attributes = attributes
    }

    private enum CodingKeys: String, CodingKey {
        case text = "@text"
        case attributes = "@attributes"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        attributes = try container.decodeIfPresent(Attributes.self, forKey: .attributes)
    }
}

public struct RSSFeedAttributesElement<Attributes: Decodable & Equatable & Hashable>: Decodable, Equatable, Hashable {
    public var attributes: Attributes?

    public init(text: String? = nil, attributes: Attributes? = nil) {
        self.attributes = attributes
    }

    private enum CodingKeys: String, CodingKey {
        case attributes = "@attributes"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attributes = try container.decodeIfPresent(Attributes.self, forKey: .attributes)
    }
}
