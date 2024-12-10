import Foundation

class XMLStack {
    private var stack: [XMLNode] = []

    func push(_ node: XMLNode) {
        stack.append(node)
    }

    @discardableResult
    func pop() -> XMLNode? {
        stack.popLast()
    }

    func top() -> XMLNode? {
        stack.last
    }

    var isEmpty: Bool {
        stack.isEmpty
    }

    var count: Int {
        stack.count
    }
}
