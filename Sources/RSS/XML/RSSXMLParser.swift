import Foundation

#if canImport(FoundationXML)
    import FoundationXML
#endif

class RSSXMLParser: NSObject {
    let parser: XMLParser
    var stack: XMLStack
    var error: XMLError?
    var isComplete = false

    init(data: Data) {
        parser = XMLParser(data: data)
        stack = XMLStack()
        super.init()
        parser.delegate = self
    }

    func parse() throws -> XMLDocument {
        guard parser.parse(), error == nil, let root = stack.pop() else {
            throw error ?? .unexpected(reason: "An unknown error occurred or the parsing operation aborted.")
        }

        return XMLDocument(root: root)
    }

    func map(_ string: String) {
        guard let element = stack.top() else { return }
        guard !string.isEmpty else { return }
        element.text = element.text?.appending(string) ?? string
    }
}

// MARK: - XMLParserDelegate

extension RSSXMLParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if attributeDict.isEmpty {
            stack.push(.init(name: elementName))
        } else {
            stack.push(
                .init(
                    name: elementName,
                    children: [
                        .init(
                            name: "@attributes",
                            children: attributeDict.map { .init(name: $0, text: $1) }
                        )
                    ])
            )
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        map(string)
    }

    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            error = .cdataDecoding(element: stack.top()?.name ?? "")
            parser.abortParsing()
            return
        }
        map(string)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let node = stack.top() else { return }

        node.text = node.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        node.text = node.text?.isEmpty == true ? nil : node.text

        guard stack.count > 1, let node = stack.pop() else {
            isComplete = true
            return
        }

        stack.top()?.children.append(node)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        guard !isComplete, error == nil else { return }
        error = .unexpected(reason: parseError.localizedDescription)
    }
}
