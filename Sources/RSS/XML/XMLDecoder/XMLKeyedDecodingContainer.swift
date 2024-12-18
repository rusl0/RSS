import Foundation

class XMLKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var decoder: _XMLDecoder
    var node: XMLNode
    var codingPath: [CodingKey] { decoder.codingPath }
    var allKeys: [Key] = []

    init(decoder: _XMLDecoder, node: XMLNode) {
        self.decoder = decoder
        self.node = node
    }

    func contains(_ key: Key) -> Bool {
        if key.stringValue == "@text" && node.text?.isEmpty == false {
            return true
        }
        return node.hasChild(for: key.stringValue)
    }

    // MARK: -

    func decodeNil(forKey key: Key) throws -> Bool {
        if key.stringValue == "@text" {
            return node.text?.isEmpty == true
        }

        if key.stringValue == "@attributes" {
            return node.children?.isEmpty == true
        }

        if let child = node.child(for: key.stringValue),
            child.text?.isEmpty ?? true && child.children?.isEmpty ?? true
        {
            return true
        }

        return false
    }

    // MARK: - Decode

    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        if key.stringValue == "@text" {
            return node.text ?? ""
        }

        return try decoder.decode(node, as: type, for: key)
    }

    // MARK: - Int

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 { try decoder.decode(node, as: type, for: key) }

    // MARK: - Unsigned Int

    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 { try decoder.decode(node, as: type, for: key) }

    // MARK: - Floating point

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float { try decoder.decode(node, as: type, for: key) }
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double { try decoder.decode(node, as: type, for: key) }

    // MARK: - Type

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }

        guard let child = node.child(for: key.stringValue) else {
            throw DecodingError.dataCorruptedError(
                forKey: key, in: self,
                debugDescription: "Failed to decode \(type) value from key: \(key.stringValue)")
        }

        return try decoder.decode(node: child, as: T.self)
    }

    // MARK: -

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError()
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
        fatalError()
    }

    func superDecoder() throws -> any Decoder {
        fatalError()
    }

    func superDecoder(forKey key: Key) throws -> any Decoder {
        fatalError()
    }
}
