public struct SearchQuery<Qualifier: SearchQualifier> {
    let rawValue: String
    var isEmpty: Bool { return rawValue.isEmpty }

    public init(keywords: SearchKeyword = [], qualifiers: Qualifier = []) {
        if keywords.isEmpty {
            self.init(rawValue: qualifiers.rawValue)
        } else if qualifiers.isEmpty {
            self.init(rawValue: keywords.rawValue)
        } else {
            self.init(rawValue: "\(keywords.rawValue)+\(qualifiers.rawValue)")
        }
    }

    private init(rawValue: String) { self.rawValue = rawValue }
}
