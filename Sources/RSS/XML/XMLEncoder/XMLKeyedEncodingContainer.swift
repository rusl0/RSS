import Foundation

class XMLKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    let encoder: _XMLEncoder
    let node: XMLNode
    var codingPath: [any CodingKey] { encoder.codingPath }

    init(node: XMLNode, encoder: _XMLEncoder) {
        self.node = node
        self.encoder = encoder
    }

    func box<T: LosslessStringConvertible>(_ value: T, for key: Key) {
        if key.stringValue == "@text" {
            node.text = "\(value)"
            return
        }
        node.children.append(.init(name: key.stringValue, text: "\(value)"))
    }

    // MARK: -

    func encodeNil(forKey key: Key) throws {
        fatalError()
    }

    func encode(_ value: Bool, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: String, forKey key: Key) throws { box(value, for: key) }

    // MARK: - Int

    func encode(_ value: Int, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: Int8, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: Int16, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: Int32, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: Int64, forKey key: Key) throws { box(value, for: key) }

    // MARK: - Unsigned Int

    func encode(_ value: UInt, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: UInt8, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: UInt16, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: UInt32, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: UInt64, forKey key: Key) throws { box(value, for: key) }

    // MARK: - Floating point

    func encode(_ value: Float, forKey key: Key) throws { box(value, for: key) }
    func encode(_ value: Double, forKey key: Key) throws { box(value, for: key) }

    // MARK: - Type

    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        encoder.codingPath.append(key)

        defer { self.encoder.codingPath.removeLast() }
        let child = try encoder.box(value)
        if node !== child {
            node.children.append(child)
        }
    }

    // MARK: -

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError()
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError()
    }

    func superEncoder() -> Encoder {
        fatalError()
    }

    func superEncoder(forKey key: Key) -> Encoder {
        fatalError()
    }
}
