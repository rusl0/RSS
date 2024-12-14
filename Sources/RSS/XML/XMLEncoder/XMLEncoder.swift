import Foundation

class XMLEncoder {
    var dateEncodingStrategy: XMLDateEncodingStrategy = .deferredToDate
    func encode<T: Codable>(value: T) throws -> XMLNode {
        let key = XMLCodingKey(stringValue: "\(type(of: value))".lowercased(), intValue: nil)
        let encoder = _XMLEncoder(codingPath: [key])
        encoder.dateEncodingStrategy = dateEncodingStrategy
        try value.encode(to: encoder)
        return encoder.node!
    }
}

class _XMLEncoder: Encoder {
    var stack: XMLStack = .init()
    var node: XMLNode? { stack.top() }
    var currentKey: String { return codingPath.last!.stringValue }
    var codingPath: [any CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    var dateEncodingStrategy: XMLDateEncodingStrategy = .deferredToDate

    init(codingPath: [CodingKey] = []) {
        stack = XMLStack()
        self.codingPath = codingPath
        userInfo = [:]
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        let node = XMLNode(name: currentKey)
        stack.push(node)
        return KeyedEncodingContainer(XMLKeyedEncodingContainer(node: node, encoder: self))
    }

    func unkeyedContainer() -> any UnkeyedEncodingContainer {
        stack.push(node!)
        return XMLUnkeyedEncodingContainer(node: stack.top()!, encoder: self)
    }

    func singleValueContainer() -> any SingleValueEncodingContainer {
        XMLSingleValueEncodingContainer(encoder: self, node: stack.top()!, codingPath: codingPath)
    }

    func box(_ date: Date) throws -> XMLNode {
        switch dateEncodingStrategy {
        case .deferredToDate:
            try date.encode(to: self)
            return stack.top()!
        case let .formatter(formatter):
            return .init(
                name: currentKey,
                text: formatter.string(from: date)
            )
        }
    }

    func box(_ value: Encodable) throws -> XMLNode {
        switch value {
        case is Date:
            return try box(value as! Date)
        default:
            try value.encode(to: self)
            return stack.pop()!
        }
    }
}
