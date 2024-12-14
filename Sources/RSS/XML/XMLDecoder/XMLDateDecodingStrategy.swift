import Foundation

enum XMLDateDecodingStrategy {
    case deferredToDate
    case formatter(DateFormatter)
}
