import struct Foundation.Date

public protocol InQualifiable: SearchQualifier {
    associatedtype InQualifier: RawRepresentable where RawValue == String
}
public extension InQualifiable {
    static func `in`(_ qualifier: InQualifier) -> Self {
        return .init(rawValue: "in:\(qualifier.rawValue)")
    }
}

public protocol UserQualifiable: SearchQualifier {}
public extension UserQualifiable {
    static func user(_ username: String) -> Self {
        return .init(rawValue: "user:\(username)")
    }
}

public protocol OrganizationQualifiable: SearchQualifier {}
public extension OrganizationQualifiable {
    static func organization(_ org: String) -> Self {
        return .init(rawValue: "org:\(org)")
    }
}

public protocol RepositoryQualifiable: SearchQualifier {}
public extension RepositoryQualifiable {
    static func repository(_ repoName: String, user username: String) -> Self {
        return .init(rawValue: "repo:\(username)/\(repoName)")
    }
    static func repo(_ repoName: String, user username: String) -> Self {
        return .repository(repoName, user: username)
    }
}

public protocol CreatedQualifiable: SearchQualifier {}
public extension CreatedQualifiable {
    static func created(on date: Date) -> Self {
        return .init(rawValue: "created:\(iso8601Formatter.string(from: date))")
    }
    static func created(after date: Date) -> Self {
        return .init(rawValue: "created:>\(iso8601Formatter.string(from: date))")
    }
    static func created(afterOrOn date: Date) -> Self {
        return .init(rawValue: "created:>=\(iso8601Formatter.string(from: date))")
    }
    static func created(before date: Date) -> Self {
        return .init(rawValue: "created:<\(iso8601Formatter.string(from: date))")
    }
    static func created(beforeOrOn date: Date) -> Self {
        return .init(rawValue: "created:<=\(iso8601Formatter.string(from: date))")
    }
    static func created(between lowerBound: Date, and upperBound: Date) -> Self {
        return .init(rawValue: "created:\(iso8601Formatter.string(from: lowerBound))..\(iso8601Formatter.string(from: upperBound))")
    }
    static func created(in range: ClosedRange<Date>) -> Self {
        return .created(between: range.lowerBound, and: range.upperBound)
    }
    static func created(in range: PartialRangeThrough<Date>) -> Self {
        return .created(beforeOrOn: range.upperBound)
    }
    static func created(in range: PartialRangeFrom<Date>) -> Self {
        return .created(afterOrOn: range.lowerBound)
    }
}

public protocol PublicPrivateQualifiable: SearchQualifier {}
public extension PublicPrivateQualifiable {
    static var isPublic: Self {
        return .init(rawValue: "is:public")
    }
    static var isPrivate: Self {
        return .init(rawValue: "is:private")
    }
    static func `is`(`public`: Bool) -> Self {
        return .init(rawValue: "is:\(`public` ? "public" : "private")")
    }
    static func `is`(`private`: Bool) -> Self {
        return .init(rawValue: "is:\(`private` ? "private" : "public")")
    }
}

public protocol ArchivedQualifiable: SearchQualifier {}
public extension ArchivedQualifiable {
    static func archived(_ archived: Bool) -> Self {
        return .init(rawValue: "archived:\(archived)")
    }
    static var isArchived: Self {
        return .archived(true)
    }
}

public protocol LanguageQualifiable: SearchQualifier {}
public extension LanguageQualifiable {
    static func language(_ lang: String) -> Self {
        return .init(rawValue: "language:\(lang)")
    }
}

public protocol ByteSizeQualifiable: SearchQualifier {
    static var sizeKey: KeyPath<ByteSize, Int> { get }
}
public extension ByteSizeQualifiable {
    static func size(equals size: ByteSize) -> Self {
        return .init(rawValue: "size:\(size[keyPath: Self.sizeKey])")
    }
    static func size(greaterThan size: ByteSize) -> Self {
        return .init(rawValue: "size:>\(size[keyPath: Self.sizeKey])")
    }
    static func size(greaterThanOrEqualTo size: ByteSize) -> Self {
        return .init(rawValue: "size:>=\(size[keyPath: Self.sizeKey])")
    }
    static func size(lessThan size: ByteSize) -> Self {
        return .init(rawValue: "size:<\(size[keyPath: Self.sizeKey])")
    }
    static func size(lessThanOrEqualTo size: ByteSize) -> Self {
        return .init(rawValue: "size:<=\(size[keyPath: Self.sizeKey])")
    }
    static func size(between lowerBound: ByteSize, and upperBound: ByteSize) -> Self {
        return .init(rawValue: "size:\(lowerBound[keyPath: Self.sizeKey])..\(upperBound[keyPath: Self.sizeKey])")
    }
    static func size(in range: ClosedRange<ByteSize>) -> Self {
        return .size(between: range.lowerBound, and: range.upperBound)
    }
    static func size(in range: PartialRangeThrough<ByteSize>) -> Self {
        return .size(lessThanOrEqualTo: range.upperBound)
    }
    static func size(in range: PartialRangeFrom<ByteSize>) -> Self {
        return .size(greaterThanOrEqualTo: range.lowerBound)
    }
}
