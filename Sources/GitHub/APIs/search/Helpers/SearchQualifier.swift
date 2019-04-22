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
            } else if !qualifier.hasPrefix("\""), !qualifier.hasSuffix("\"") {
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

public enum SortOrdering: String, RestfulParameter {
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

public struct ByteSize: RawRepresentable, ExpressibleByIntegerLiteral, Equatable, Comparable, Codable, Hashable {
    public let rawValue: Int

    public var bytes: Int { return rawValue }
    public var kilobytes: Int { return rawValue * 1024 }
    public var megabytes: Int { return kilobytes * 1024 }
    public var gigabytes: Int { return megabytes * 1024 }

    public var b: Int { return bytes }
    public var kb: Int { return kilobytes }
    public var mb: Int { return megabytes }
    public var gb: Int { return gigabytes }

    public static func bytes(_ value: Int) -> ByteSize {
        return .init(rawValue: value)
    }

    public static func kilobytes(_ value: Int) -> ByteSize {
        return .init(rawValue: value * 1024)
    }

    public static func megabytes(_ value: Int) -> ByteSize {
        return .init(rawValue: value * 1024 * 1024)
    }

    public static func gigabytes(_ value: Int) -> ByteSize {
        return .init(rawValue: value * 1024 * 1024 * 1024)
    }

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }

    public static func < (lhs: ByteSize, rhs: ByteSize) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public extension Int {
    var bytes: ByteSize { return .bytes(self) }
    var kilobytes: ByteSize { return .kilobytes(self) }
    var megabytes: ByteSize { return .megabytes(self) }
    var gigabytes: ByteSize { return .gigabytes(self) }

    var b: ByteSize { return bytes }
    var kb: ByteSize { return kilobytes }
    var mb: ByteSize { return megabytes }
    var gb: ByteSize { return gigabytes }
}
