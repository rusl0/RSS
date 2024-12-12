import Foundation

extension URL {
    func replacingScheme<Target, Replacement>(
        _ target: Target,
        with replacement: Replacement
    ) -> URL? where Target: StringProtocol, Replacement: StringProtocol {
        guard
            let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let currentScheme = urlComponents.scheme,
            currentScheme.caseInsensitiveCompare(target) == .orderedSame
        else {
            return nil
        }

        var modifiedComponents = urlComponents
        modifiedComponents.scheme = String(replacement)

        return modifiedComponents.url
    }
}
