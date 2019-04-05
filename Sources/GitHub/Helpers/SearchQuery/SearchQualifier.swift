import class Foundation.ISO8601DateFormatter

let iso8601Formatter = ISO8601DateFormatter()

public protocol SearchQualifier: ExpressibleByStringLiteral, OptionSet {
    var _qualifiers: Set<String> { get set }

    init()
}

public extension SearchQualifier {
    var rawValue: String { return _qualifiers.joined(separator: "+") }

    init(rawValue: String) {
        self.init()
        _qualifiers = Set(rawValue.split(separator: "+").map { qualifier in
            guard qualifier.contains(" ") else { return String(qualifier) }

            if qualifier.contains(":") {
                let parts = qualifier.split(separator: ":", maxSplits: 1)
                let key = parts.first!
                let value = parts.last!
                guard value.hasPrefix("\""), value.hasSuffix("\"") else {
                    return "\(key):\"\(value)\""
                }

                return String(qualifier)
            } else if !qualifier.hasPrefix("\"") && !qualifier.hasSuffix("\"") {
                return "\"\(qualifier)\""
            }

            return String(qualifier)
        })
    }
    init(stringLiteral value: String) { self.init(rawValue: value) }

    mutating func formUnion(_ other: Self) {
        _qualifiers.formUnion(other._qualifiers)
    }
    mutating func formIntersection(_ other: Self) {
        _qualifiers.formIntersection(other._qualifiers)
    }
    mutating func formSymmetricDifference(_ other: Self) {
        _qualifiers.formSymmetricDifference(other._qualifiers)
    }
}

public enum ForkSearch: String {
    case `true`
    case only
}

// MARK: Support searching in forks
public extension SearchQualifier {
    static func fork(_ fork: ForkSearch) -> Self {
        return .init(rawValue: "fork:\(fork.rawValue)")
    }
}

public enum SortOrdering: String {
    case asc
    case desc

    public static let ascending: SortOrdering = .asc
    public static let descending: SortOrdering = .desc
    public static let `default`: SortOrdering = .desc
}

public enum ReactionType: String {
    case plus1 = "+1"
    public static let thumbsUp = ReactionType.plus1
    case minus1 = "-1"
    public static let thumbsDown = ReactionType.minus1
    case smile
    case tada
    public static let hurray = ReactionType.tada
    case heart
}

// MARK: Support sort qualifiers
public extension SearchQualifier {
    static func sortBy(interactions sort: SortOrdering) -> Self {
        return .init(rawValue: "sort:interactions-\(sort.rawValue)")
    }

    static func sortBy(reactions sort: SortOrdering) -> Self {
        return .init(rawValue: "sort:reactions-\(sort.rawValue)")
    }
    static func sortBy(reactions type: ReactionType) -> Self {
        return .init(rawValue: "sort:reactions-\(type.rawValue)")
    }

    static func sortBy(authorDate sort: SortOrdering) -> Self {
        return .init(rawValue: "sort:author-date-\(sort.rawValue)")
    }

    static func sortBy(committerDate sort: SortOrdering) -> Self {
        return .init(rawValue: "sort:committer-date-\(sort.rawValue)")
    }

    static func sortBy(updated sort: SortOrdering) -> Self {
        return .init(rawValue: "sort:updated-\(sort.rawValue)")
    }
}

// MARK: Support excluding qualifiers
public extension SearchQualifier {
    static func exclude(_ qualifier: Self) -> Self {
        var raw: String = ""
        for qual in qualifier._qualifiers {
            raw += "-\(qual)"
        }
        return .init(rawValue: raw)
    }
}
