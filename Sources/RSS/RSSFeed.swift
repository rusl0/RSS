import Foundation

#if canImport(FoundationXML)
    import FoundationXML
#endif

public struct RSSFeed: RSSFeedInitializable {

    init(data: Data) throws {
        let parser = RSSXMLParser(data: data)
        let result = try parser.parse()

    }

}
