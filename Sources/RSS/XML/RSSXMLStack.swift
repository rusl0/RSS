import Foundation

class RSSXMLStack {
    private var stack: [RSSXMLNode] = []

    func push(_ node: RSSXMLNode) {
        stack.append(node)
    }

    @discardableResult
    func pop() -> RSSXMLNode? {
        stack.popLast()
    }

    func top() -> RSSXMLNode? {
        stack.last
    }

    var isEmpty: Bool {
        stack.isEmpty
    }

    var count: Int {
        stack.count
    }
}
