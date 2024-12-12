//
//  XMLSingleValueEncodingContainer.swift
//
//  Copyright (c) 2016 - 2024 Nuno Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

class XMLSingleValueEncodingContainer: SingleValueEncodingContainer {
  /// The XML encoder used for encoding.
  let encoder: _XMLEncoder
  /// The XML node being encoded.
  let node: XMLNode
  /// The coding path of the current encoding process.
  var codingPath: [any CodingKey]

  /// Initializes a container for encoding values to an XML node.
  /// - Parameters:
  ///   - encoder: The XML encoder used for encoding.
  ///   - node: The XML node to encode values to.
  ///   - codingPath: The coding path representing the current encoding state.
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
