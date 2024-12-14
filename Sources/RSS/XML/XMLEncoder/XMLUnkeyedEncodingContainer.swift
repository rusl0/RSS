import Foundation

class XMLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    let encoder: _XMLEncoder
    let node: XMLNode
    var codingPath: [CodingKey] { encoder.codingPath }
    var count: Int = 0

    init(node: XMLNode, encoder: _XMLEncoder) {
        self.node = node
        self.encoder = encoder
    }

    func box<T: LosslessStringConvertible>(_ value: T) -> XMLNode {
        .init(name: encoder.currentKey, text: "\(value)")
    }

    // MARK: -

    func encodeNil() throws {}

    func encode(_ value: Bool) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: String) throws {
        node.children?.append(box(value))
        count += 1
    }

    // MARK: - Int

    func encode(_ value: Int) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: Int8) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: Int16) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: Int32) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: Int64) throws {
        node.children?.append(box(value))
        count += 1
    }

    // MARK: - Unsigned Int

    func encode(_ value: UInt) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: UInt8) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: UInt16) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: UInt32) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: UInt64) throws {
        node.children?.append(box(value))
        count += 1
    }

    // MARK: - Floating point

    func encode(_ value: Float) throws {
        node.children?.append(box(value))
        count += 1
    }
    func encode(_ value: Double) throws {
        node.children?.append(box(value))
        count += 1
    }

    // MARK: - Type

    func encode<T>(_ value: T) throws where T: Encodable {
        encoder.codingPath.append(XMLCodingKey(stringValue: encoder.currentKey, intValue: count))
        defer { self.encoder.codingPath.removeLast() }

        let child = try encoder.box(value)
        if node !== child {
            node.children.append(child)
        }
        count += 1
    }

    // MARK: -

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError()
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }

    func superEncoder() -> Encoder {
        fatalError()
    }
}
