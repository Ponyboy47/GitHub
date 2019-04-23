import struct Foundation.Date

public struct CommitQualifier: SearchQualifier {
    public var _qualifiers = Set<String>()

    public init() {}
}

// MARK: Support author and commit qualifiers

public extension CommitQualifier {
    static func author(username: String) -> CommitQualifier {
        return .init(rawValue: "author:\(username)")
    }

    static func author(name: String) -> CommitQualifier {
        return .init(rawValue: "author-name:\(name)")
    }

    static func author(email: String) -> CommitQualifier {
        return .init(rawValue: "author-email:\(email)")
    }

    static func committer(username: String) -> CommitQualifier {
        return .init(rawValue: "committer:\(username)")
    }

    static func committer(name: String) -> CommitQualifier {
        return .init(rawValue: "committer-name:\(name)")
    }

    static func committer(email: String) -> CommitQualifier {
        return .init(rawValue: "committer-email:\(email)")
    }

    static func authored(on date: Date) -> CommitQualifier {
        return .init(rawValue: "author-date:\(date.iso8601)")
    }

    static func authored(after date: Date) -> CommitQualifier {
        return .init(rawValue: "author-date:>\(date.iso8601)")
    }

    static func authored(afterOrOn date: Date) -> CommitQualifier {
        return .init(rawValue: "author-date:>=\(date.iso8601)")
    }

    static func authored(before date: Date) -> CommitQualifier {
        return .init(rawValue: "author-date:<\(date.iso8601)")
    }

    static func authored(beforeOrOn date: Date) -> CommitQualifier {
        return .init(rawValue: "author-date:<=\(date.iso8601)")
    }

    static func authored(between lowerBound: Date, and upperBound: Date) -> CommitQualifier {
        return .init(rawValue: "author-date:\(lowerBound.iso8601)..\(upperBound.iso8601)")
    }

    static func authored(in range: ClosedRange<Date>) -> CommitQualifier {
        return .authored(between: range.lowerBound, and: range.upperBound)
    }

    static func authored(in range: PartialRangeThrough<Date>) -> CommitQualifier {
        return .authored(beforeOrOn: range.upperBound)
    }

    static func authored(in range: PartialRangeFrom<Date>) -> CommitQualifier {
        return .authored(afterOrOn: range.lowerBound)
    }

    static func committed(on date: Date) -> CommitQualifier {
        return .init(rawValue: "committer-date:\(date.iso8601)")
    }

    static func committed(after date: Date) -> CommitQualifier {
        return .init(rawValue: "committer-date:>\(date.iso8601)")
    }

    static func committed(afterOrOn date: Date) -> CommitQualifier {
        return .init(rawValue: "committer-date:>=\(date.iso8601)")
    }

    static func committed(before date: Date) -> CommitQualifier {
        return .init(rawValue: "committer-date:<\(date.iso8601)")
    }

    static func committed(beforeOrOn date: Date) -> CommitQualifier {
        return .init(rawValue: "committer-date:<=\(date.iso8601)")
    }

    static func committed(between lowerBound: Date, and upperBound: Date) -> CommitQualifier {
        return .init(rawValue: "committer-date:\(lowerBound.iso8601)..\(upperBound.iso8601)")
    }

    static func committed(in range: ClosedRange<Date>) -> CommitQualifier {
        return .committed(between: range.lowerBound, and: range.upperBound)
    }

    static func committed(in range: PartialRangeThrough<Date>) -> CommitQualifier {
        return .committed(beforeOrOn: range.upperBound)
    }

    static func committed(in range: PartialRangeFrom<Date>) -> CommitQualifier {
        return .committed(afterOrOn: range.lowerBound)
    }
}

// MARK: Support merge commit qualifier

public extension CommitQualifier {
    static func merge(_ merge: Bool) -> CommitQualifier {
        return .init(rawValue: "merge:\(merge)")
    }
}

// MARK: Support commit hash qualifier

public extension CommitQualifier {
    static func hash(_ hash: String) -> CommitQualifier {
        return .init(rawValue: "hash:\(hash)")
    }
}

// MARK: Support tree/parent hash qualifiers

public extension CommitQualifier {
    static func parent(hash: String) -> CommitQualifier {
        return .init(rawValue: "parent:\(hash)")
    }

    static func tree(hash: String) -> CommitQualifier {
        return .init(rawValue: "tree:\(hash)")
    }
}

// MARK: Support qualifiers for user, organization, and repository

extension CommitQualifier: UserQualifiable {}
extension CommitQualifier: OrganizationQualifiable {}
extension CommitQualifier: RepositoryQualifiable {}

// MARK: Support qualifier for public or private repos

extension CommitQualifier: PublicPrivateQualifiable {}
