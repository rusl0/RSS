import Foundation

class RSSXMLNode {
    weak var parent: RSSXMLNode?
    var name: String
    var text: String?
    var children: [RSSXMLNode]? {
        didSet { children?.forEach { $0.parent = self } }
    }

    init(name: String, text: String? = nil, children: [RSSXMLNode]? = nil) {
        self.name = name
        self.text = text
        self.children = children
        children?.forEach { $0.parent = self }
    }

    func child(for name: String) -> RSSXMLNode? {
        children?.first(where: { $0.name == name })
    }

    func hasChild(for name: String) -> Bool {
        children?.first(where: { $0.name == name }) != nil
    }
}

extension RSSXMLNode: Equatable {
    static func == (lhs: RSSXMLNode, rhs: RSSXMLNode) -> Bool {
        if lhs.name != rhs.name || lhs.text != rhs.text {
            return false
        }

        let lhsChildren = lhs.children ?? []
        let rhsChildren = rhs.children ?? []
        if lhsChildren.count != rhsChildren.count {
            return false
        }

        for (lChild, rChild) in zip(lhsChildren, rhsChildren) {
            if lChild.name != rChild.name || lChild.text != rChild.text {
                return false
            }
        }

        return true
    }
}

extension RSSXMLNode: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(text)

        if let children = children {
            hasher.combine(children.map { $0.hashValue })
        }
    }
}

extension RSSXMLNode: RSSXMLStringConvertible {
    func toXMLString(formatted: Bool, indentationLevel: Int) -> String {
        let indent = formatted ? String(repeating: "  ", count: indentationLevel) : ""

        if name == "@attributes" {
            return ""
        }

        var xml = "\(indent)<\(name)"
        if let attributesNode = children?.first(where: { $0.name == "@attributes" }) {
            for attribute in attributesNode.children ?? [] {
                xml += " \(attribute.name)=\"\(attribute.text ?? "")\""
            }
        }

        if let children = children?.filter({ $0.name != "@attributes" }), !children.isEmpty {
            xml += ">\(formatted ? "\n" : "")"
            for child in children {
                xml += child.toXMLString(
                    formatted: formatted,
                    indentationLevel: indentationLevel + 1
                )
            }
            xml += "\(formatted ? indent : "")</\(name)>\(formatted ? "\n" : "")"
        } else if let text {
            xml += ">\(text)</\(name)>\(formatted ? "\n" : "")"
        } else {
            xml += " />\(formatted ? "\n" : "")"
        }
        return xml
    }
}
