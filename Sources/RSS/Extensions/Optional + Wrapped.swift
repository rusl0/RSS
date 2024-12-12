import Foundation

extension Optional where Wrapped: RangeReplaceableCollection {
    mutating func append(_ value: Wrapped.Element) {
        if self == nil {
            self = [value] as? Wrapped
        } else {
            self?.append(value)
        }
    }
}
