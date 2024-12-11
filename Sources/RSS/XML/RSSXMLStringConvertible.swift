import Foundation

protocol RSSXMLStringConvertible {
    func toXMLString(formatted: Bool, indentationLevel: Int) -> String
}
