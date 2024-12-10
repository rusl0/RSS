import Foundation

class XMLNode {
    weak var parent: XMLNode?
    var name: String
    var text: String?
    var children: [XMLNode]? {
        didSet {
            children?.forEach {$0.parent = self}
        }
    }

    init(name: String, text: String? = nil, children: [XMLNode]? = nil) {
        self.name = name
        self.text = text
        self.children = children
        children?.forEach { $0.parent = self }
    }
}

class XMLDocument {
    var root: XMLNode?

    init(root: XMLNode?) {
        self.root = root
    }
}