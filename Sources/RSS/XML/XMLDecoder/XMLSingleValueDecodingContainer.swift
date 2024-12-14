import Foundation

class XMLSingleValueDecodingContainer: SingleValueDecodingContainer {
    var decoder: _XMLDecoder
    var node: XMLNode
    var codingPath: [any CodingKey] { decoder.codingPath }

    init(
        decoder: _XMLDecoder,
        node: XMLNode
    ) {
        self.decoder = decoder
        self.node = node
    }

    // MARK: -

    func decodeNil() -> Bool {
        if node.text?.isEmpty ?? true && node.children?.isEmpty ?? true {
            return true
        }
        return false
    }

    func decode(_ type: Bool.Type) throws -> Bool { try decoder.decode(node, as: type) }
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

    // MARK: - Unsigned Int

    func decode(_ type: UInt.Type) throws -> UInt { try decoder.decode(node, as: type) }
    func decode(_ type: UInt8.Type) throws -> UInt8 { try decoder.decode(node, as: type) }
    func decode(_ type: UInt16.Type) throws -> UInt16 { try decoder.decode(node, as: type) }
    func decode(_ type: UInt32.Type) throws -> UInt32 { try decoder.decode(node, as: type) }
    func decode(_ type: UInt64.Type) throws -> UInt64 { try decoder.decode(node, as: type) }

    // MARK: - Type

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable { try type.init(from: decoder) }
}
