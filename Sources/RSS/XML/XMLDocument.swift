import Foundation

class XMLDocument: Equatable, Hashable {
    var root: XMLNode?

    init(root: XMLNode?) {
        self.root = root
    }

    // MARK: Equatable

    static func == (lhs: XMLDocument, rhs: XMLDocument) -> Bool {
        lhs.root == rhs.root
    }

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(root)
    }
}

class XMLNode: Codable, Equatable, Hashable {
    weak var parent: XMLNode?
    var name: String
    var text: String?

    var children: [XMLNode]? {
        didSet { children?.forEach { $0.parent = self } }
    }

    init(name: String, text: String? = nil, attributes: [String: String]? = nil, children: [XMLNode]? = nil) {
        self.name = name
        self.text = text
        self.children = children
        self.children?.forEach { $0.parent = self }
    }

    // MARK: Equatable

    static func == (lhs: XMLNode, rhs: XMLNode) -> Bool {
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

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(text)

        if let children = children {
            hasher.combine(children.map { $0.hashValue })
        }
    }

    func child(for name: String) -> XMLNode? {
        children?.first(where: { $0.name == name })
    }

    func hasChild(for name: String) -> Bool {
        children?.first(where: { $0.name == name }) != nil
    }
}

// MARK: - XMLStringConvertible

protocol XMLStringConvertible {
    func toXMLString(formatted: Bool, indentationLevel: Int) -> String
}

// MARK: - XMLDocument + XMLStringConvertible

extension XMLDocument: XMLStringConvertible {
    func toXMLString(formatted: Bool = false, indentationLevel: Int = 1) -> String {
        guard let root = root else { return "" }

        let header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        let body = root.toXMLString(formatted: formatted, indentationLevel: 0)

        return "\(header)\(formatted ? "\n" : "")\(body)"
    }
}

// MARK: - XMLNode + XMLStringConvertible

extension XMLNode: XMLStringConvertible {

    func toXMLString(formatted: Bool = false, indentationLevel: Int = 1) -> String {
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
