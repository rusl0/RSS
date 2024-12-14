import Foundation

public struct RSSFeed {
    public var channel: RSSFeedChannel?

    public init(channel: RSSFeedChannel? = nil) {
        self.channel = channel
    }

    public init(data: Data) throws {
        let parser = RSSXMLParser(data: data)
        let result = try parser.parse()

        guard let rootNode = result.root else {
            throw XMLError.unexpected(reason: "Unexpected parsing result. Root node is nil.")
        }

        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .formatter(FeedDateFormatter(spec: .permissive))
        self = try decoder.decode(Self.self, from: rootNode)
    }
}

// MARK: - Equatable

extension RSSFeed: Equatable {}

// MARK: - Hashable

extension RSSFeed: Hashable {}

// MARK: - Codable

extension RSSFeed: Codable {
    private enum CodingKeys: CodingKey {
        case channel
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<RSSFeed.CodingKeys> = try decoder.container(keyedBy: RSSFeed.CodingKeys.self)

        channel = try container.decodeIfPresent(RSSFeedChannel.self, forKey: RSSFeed.CodingKeys.channel)
    }

    public func encode(to encoder: any Encoder) throws {
        var container: KeyedEncodingContainer<RSSFeed.CodingKeys> = encoder.container(keyedBy: RSSFeed.CodingKeys.self)

        try container.encodeIfPresent(channel, forKey: RSSFeed.CodingKeys.channel)
    }
}
