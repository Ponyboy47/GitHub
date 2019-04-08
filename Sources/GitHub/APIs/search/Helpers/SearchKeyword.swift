public struct SearchKeyword: ExpressibleByStringLiteral, RawRepresentable, OptionSet {
    public var rawValue: String { return keywords.joined(separator: "+") }
    private var keywords: Set<String>

    public static func not(_ keyword: SearchKeyword) -> SearchKeyword {
        var raw: String = ""
        for key in keyword.keywords {
            raw += "NOT \(key)"
        }
        return .init(rawValue: raw)
    }

    public init() { self.init(rawValue: "") }
    public init(rawValue: String) {
        keywords = Set(rawValue.split(separator: "+").map { keyword in
            guard keyword.contains(" ") else { return String(keyword) }

            if keyword.hasPrefix("NOT ") {
                let key = keyword.components(separatedBy: "NOT ").last!
                guard key.contains(" "), !key.hasPrefix("\""), !key.hasSuffix("\"") else {
                    return String(keyword)
                }

                return "NOT \"\(key)\""
            } else if !keyword.hasPrefix("\"") && !keyword.hasSuffix("\"") {
                return "\"\(keyword)\""
            }

            return String(keyword)
        })
    }
    public init(stringLiteral value: String) { self.init(rawValue: value) }

    public mutating func formUnion(_ other: SearchKeyword) {
        keywords.formUnion(other.keywords)
    }
    public mutating func formIntersection(_ other: SearchKeyword) {
        keywords.formIntersection(other.keywords)
    }
    public mutating func formSymmetricDifference(_ other: SearchKeyword) {
        keywords.formSymmetricDifference(other.keywords)
    }
}
