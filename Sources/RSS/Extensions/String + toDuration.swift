import Foundation

extension String {
    /// Convert the string representation of a time duration to a Time Interval.
    ///
    /// - Returns: A TimeInterval.
    func toDuration() -> TimeInterval? {
        let comps = trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ":")

        guard
            !comps.contains(where: { Int($0) == nil }),
            !comps.contains(where: { Int($0)! < 0 })
        else { return nil }

        return
            comps
            .reversed()
            .enumerated()
            .map { i, e in
                (Double(e) ?? 0)
                    * pow(Double(60), Double(i))
            }
            .reduce(0, +)
    }
}
