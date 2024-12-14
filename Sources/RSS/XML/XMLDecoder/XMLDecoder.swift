import Foundation

class XMLDecoder {
    var dateDecodingStrategy: XMLDateDecodingStrategy = .deferredToDate

    func decode<T>(_ type: T.Type, from node: XMLNode) throws -> T where T: Decodable {
        let decoder = _XMLDecoder(node: node, codingPath: [])
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return try T(from: decoder)
    }
}

class _XMLDecoder: Decoder {
    var stack: XMLStack
    var codingPath: [any CodingKey]
    var userInfo: [CodingUserInfoKey: Any]
    var dateDecodingStrategy: XMLDateDecodingStrategy = .deferredToDate

    init(node: XMLNode, codingPath: [CodingKey] = []) {
        stack = XMLStack()
        stack.push(node)
        self.codingPath = codingPath
        userInfo = [:]
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        KeyedDecodingContainer(
            XMLKeyedDecodingContainer<Key>(
                decoder: self,
                node: stack.top()!
            ))
    }

    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        XMLUnkeyedDecodingContainer(
            decoder: self,
            node: stack.top()!
        )
    }

    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        XMLSingleValueDecodingContainer(
            decoder: self,
            node: stack.top()!
        )
    }

    // MARK: -

    func decode<T: Decodable>(node: XMLNode, as type: T.Type) throws -> T {
        switch T.self {
        case is Date.Type:
            return try decode(node: node, as: Date.self) as! T
        default:
            stack.push(node)
            defer { stack.pop() }
            return try type.init(from: self)
        }
    }

    func decode(node: XMLNode, as type: Date.Type) throws -> Date {
        switch dateDecodingStrategy {
        case .deferredToDate:
            return try Date(from: self)
        case let .formatter(formatter):
            stack.push(node)
            defer { stack.pop() }
            guard
                let stringDate = node.text,
                let date = formatter.date(from: stringDate)
            else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: codingPath,
                        debugDescription: "Unable to decode date with formatter: \(formatter)"
                    ))
            }
            return date
        }
    }

    func decode<T: LosslessStringConvertible>(_ node: XMLNode, as type: T.Type) throws -> T {
        guard let text = node.text, let value = T(text) else {
            throw DecodingError.valueNotFound(
                type,
                .init(
                    codingPath: codingPath,
                    debugDescription: "Expected text but found nil"
                ))
        }
        return value
    }

    func decode<T: LosslessStringConvertible, Key: CodingKey>(_ node: XMLNode, as type: T.Type, for key: Key) throws -> T {
        guard
            let child = node.child(for: key.stringValue),
            let text = child.text,
            let value = T(text)
        else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: codingPath,
                    debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)"
                ))
        }
        return value
    }
}
