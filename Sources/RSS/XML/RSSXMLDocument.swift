import Foundation

class RSSXMLDocument {
    var root: RSSXMLNode?

    init(root: RSSXMLNode?) {
        self.root = root
    }
}

extension RSSXMLDocument: RSSXMLStringConvertible {
    func toXMLString(formatted: Bool = false, indentationLevel: Int = 1) -> String {
        guard let root = root else { return "" }

        let header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        let body = root.toXMLString(formatted: formatted, indentationLevel: 0)
        return "\(header)\(formatted ? "\n" : "")\(body)"
    }
}
