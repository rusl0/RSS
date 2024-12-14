import Foundation

class XMLUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    var decoder: _XMLDecoder
    var nodes: [XMLNode]
    var node: XMLNode { nodes[currentIndex] }
    var codingPath: [CodingKey] { decoder.codingPath }
    var count: Int? { nodes.count }
    var isAtEnd: Bool { currentIndex >= count ?? 0 }
    var currentIndex: Int = 0

    init(decoder: _XMLDecoder, node: XMLNode) {
        self.decoder = decoder
        if let parent = node.parent {
            decoder.stack.pop()
            decoder.stack.push(parent)
            nodes =
                parent.children?.filter {
                    $0.name == decoder.codingPath.last!.stringValue
                } ?? []
        } else {
            nodes = []
        }
    }

    // MARK: - Decode

    func decodeNil() throws -> Bool {
        fatalError()
    }

    func decode(_ type: Bool.Type) throws -> Bool {
        fatalError()
    }

    func decode(_ type: String.Type) throws -> String { try decoder.decode(node, as: type) }

    // MARK: - Floating point

    func decode(_ type: Float.Type) throws -> Float { try decoder.decode(node, as: type) }
    func decode(_ type: Double.Type) throws -> Double { try decoder.decode(node, as: type) }

    // MARK: - Int

    func decode(_ type: Int.Type) throws -> Int { try decoder.decode(node, as: type) }
    func decode(_ type: Int8.Type) throws -> Int8 { try decoder.decode(node, as: type) }
    func decode(_ type: Int16.Type) throws -> Int16 { try decoder.decode(node, as: type) }
    func decode(_ type: Int32.Type) throws -> Int32 { try decoder.decode(node, as: type) }
    func decode(_ type: Int64.Type) throws -> Int64 { try decoder.decode(node, as: type) }

    // MARK: - Int

    func decode(_ type: UInt.Type) throws -> UInt { try decoder.decode(node, as: type) }
    func decode(_ type: UInt8.Type) throws -> UInt8 { try decoder.decode(node, as: type) }
    func decode(_ type: UInt16.Type) throws -> UInt16 { try decoder.decode(node, as: type) }
    func decode(_ type: UInt32.Type) throws -> UInt32 { try decoder.decode(node, as: type) }
    func decode(_ type: UInt64.Type) throws -> UInt64 { try decoder.decode(node, as: type) }

    // MARK: - Type

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(
                T.self,
                .init(
                    codingPath: codingPath,
                    debugDescription: "Unkeyed container is at end."
                ))
        }

        let node = nodes[currentIndex]
        let value = try decoder.decode(node: node, as: type)
        currentIndex += 1
        return value
    }

    // MARK: -

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError()
    }

    func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
        fatalError()
    }

    func superDecoder() throws -> any Decoder {
        fatalError()
    }
}
