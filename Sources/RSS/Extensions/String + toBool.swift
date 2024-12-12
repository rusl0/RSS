import Foundation

extension String {
    func toBool() -> Bool? {
        switch lowercased() {
        case "true", "y", "yes", "1": return true
        case "false", "n", "no", "0": return false
        default: return nil
        }
    }
}
