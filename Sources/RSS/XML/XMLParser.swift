import Foundation

#if canImport(FoundationXML)
    import FoundationXML
#endif

class XMLParser: NSObject {
    let parser: FoundationXML.XMLParser
    var stack: XMLStack
    var error: XMLError?
    var isComplete = false

    init(data: Data) {
        self.parser = FoundationXML.XMLParser(data: data)
        self.stack = XMLStack()
        super.init()
        self.parser.delegate = self
    }

    func parse() -> Result<XMLDocument, XMLError> {
        guard parser.parse(), error == nil, let root = stack.pop() else {
            let error = error ?? .unexpected(reason: "An unknown error occurred or the parsing operation aborted.")
            return .failure(error)
        }

        return .success(.init(root: root))
    }

    func map(_ string: String) {
        guard let element = stack.top() else { return }
        guard !string.isEmpty else { return }
        element.text = element.text?.appending(string) ?? string
    }
}

// MARK: - XMLParserDelegate
extension XMLParser: XMLParserDelegate {

    func parser(
        _ parser: FoundationXML.XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        if attributeDict.isEmpty {
            stack.push(.init(name: elementName))
        } else {
            stack.push(
                .init(
                    name: elementName,
                    children: [
                        .init(
                            name: "@attributes",
                            children: attributeDict.map {
                                .init(
                                    name: $0, text: $1
                                )
                            }
                        )
                    ])
            )
        }
    }

    func parser(_ parser: FoundationXML.XMLParser, foundCharacters string: String) {
        map(string)
    }

    func parser(_ parser: FoundationXML.XMLParser, foundCDATA CDATABlock: Data) {
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            self.error = .cdataDecoding(element: stack.top()?.name ?? "")
            parser.abortParsing()
            return
        }
        map(string)
    }

    func parser(
        _ parser: FoundationXML.XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        guard let node = stack.top() else { return }

        // If exiting an XHTML element, close it as plain text.
        if node.name != elementName {
            node.text = (node.text ?? "") + "</\(elementName)>"
            return
        }

        // Sanitize the node's text by trimming whitespace and newlines.
        // If the resulting text is empty, set it to nil.
        node.text = node.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        node.text = node.text?.isEmpty == true ? nil : node.text

        guard stack.count > 1, let node = stack.pop() else {
            isComplete = true
            return
        }

        stack.top()?.children?.append(node)
    }

    func parserDidEndDocument(
        _ parser: FoundationXML.XMLParser
    ) {
        #if DEBUG
            if !isComplete {
                print("Parsing ended without reaching the root path.")
            }
        #endif
    }

    func parser(_ parser: FoundationXML.XMLParser, parseErrorOccurred parseError: Error) {
        guard !isComplete, error == nil else { return }
        error = .unexpected(reason: parseError.localizedDescription)
    }
}
