import Foundation

class XMLSingleValueEncodingContainer: SingleValueEncodingContainer {
    let encoder: _XMLEncoder
    let node: XMLNode
    var codingPath: [any CodingKey]

    init(encoder: _XMLEncoder, node: XMLNode, codingPath: [any CodingKey]) {
        self.encoder = encoder
        self.node = node
        self.codingPath = codingPath
    }

    func push(_ node: XMLNode) {
        encoder.stack.push(node)
    }

    func box<T: LosslessStringConvertible>(_ value: T) -> XMLNode {
        .init(
            name: encoder.currentKey,
            text: "\(value)"
        )
    }

    // MARK: -

    func encodeNil() throws { fatalError() }

    func encode(_ value: Bool) throws { push(box(value)) }
    func encode(_ value: String) throws { push(box(value)) }

    // MARK: - Int

    func encode(_ value: Int) throws { push(box(value)) }
    func encode(_ value: Int8) throws { push(box(value)) }
    func encode(_ value: Int16) throws { push(box(value)) }
    func encode(_ value: Int32) throws { push(box(value)) }
    func encode(_ value: Int64) throws { push(box(value)) }

    // MARK: - Unsigned Int

    func encode(_ value: UInt) throws { push(box(value)) }
    func encode(_ value: UInt8) throws { push(box(value)) }
    func encode(_ value: UInt16) throws { push(box(value)) }
    func encode(_ value: UInt32) throws { push(box(value)) }
    func encode(_ value: UInt64) throws { push(box(value)) }

    // MARK: - Floating point

    func encode(_ value: Float) throws { push(box(value)) }
    func encode(_ value: Double) throws { push(box(value)) }

    // MARK: - Encode Type

    func encode<T>(_ value: T) throws where T: Encodable {
        let some = try encoder.box(value)
        encoder.stack.push(some)
    }
}
