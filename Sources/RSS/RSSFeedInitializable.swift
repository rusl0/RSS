import Foundation

protocol RSSFeedInitializable {
    init()
    init(url: URL) throws
    init(string: String) throws
    init(data: Data) throws
}

extension RSSFeedInitializable {
    init() {
        self.init()
    }

    init(url: URL) throws {
        fatalError()
    }

    init(string: String) throws {
        fatalError()
    }

    init(data: Data) throws {
        fatalError()
    }
}
