import Foundation

public struct RSSFeedSkipHours {
    public var hours: [Int]?
}

// MARK: - Equatable

extension RSSFeedSkipHours: Equatable {}

// MARK: - Hashable

extension RSSFeedSkipHours: Hashable {}

// MARK: - Codable

extension RSSFeedSkipHours: Decodable {
    private enum CodingKeys: CodingKey {
        case hour
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<RSSFeedSkipHours.CodingKeys> = try decoder.container(keyedBy: RSSFeedSkipHours.CodingKeys.self)

        hours = try container.decodeIfPresent([Int].self, forKey: RSSFeedSkipHours.CodingKeys.hour)
    }
}
