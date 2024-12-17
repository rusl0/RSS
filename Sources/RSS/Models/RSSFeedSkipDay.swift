import Foundation

public enum RSSFeedSkipDay: String, Equatable, Hashable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

extension RSSFeedSkipDay {
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "monday": self = .monday
        case "tuesday": self = .tuesday
        case "wednesday": self = .wednesday
        case "thursday": self = .thursday
        case "friday": self = .friday
        case "saturday": self = .saturday
        case "sunday": self = .sunday
        default: return nil
        }
    }
}

public struct RSSFeedSkipDays {
    public var days: [RSSFeedSkipDay]?
}

// MARK: - Equatable

extension RSSFeedSkipDays: Equatable {}

// MARK: - Hashable

extension RSSFeedSkipDays: Hashable {}

// MARK: - Codable

extension RSSFeedSkipDays: Decodable {
    private enum CodingKeys: CodingKey {
        case day
    }

    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<RSSFeedSkipDays.CodingKeys> = try decoder.container(keyedBy: RSSFeedSkipDays.CodingKeys.self)

        days = try container.decodeIfPresent([RSSFeedSkipDay].self, forKey: RSSFeedSkipDays.CodingKeys.day)
    }
}
