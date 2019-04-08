public struct UserQualifier: SearchQualifier {
    public var _qualifiers = Set<String>()

    public init() {}
}

// MARK: Support qualifying based on the user type
public extension UserQualifier {
    enum UserType: String {
        case user
        case org
        public static let organization = UserType.org
    }
    static func type(_ type: UserType) -> UserQualifier {
        return .init(rawValue: "type:\(type.rawValue)")
    }
}

// MARK: Support `in:qualifier`
extension UserQualifier: InQualifiable {
    public enum InQualifier: String {
        case login
        public static let username = InQualifier.login
        case fullname
        case email
    }
}

// MARK: Support qualifying based on number of owned repos
public extension UserQualifier {
    static func repos(equals repos: Int) -> UserQualifier {
        return .init(rawValue: "repos:\(repos)")
    }
    static func repos(greaterThan repos: Int) -> UserQualifier {
        return .init(rawValue: "repos:>\(repos)")
    }
    static func repos(greaterThanOrEqualTo repos: Int) -> UserQualifier {
        return .init(rawValue: "repos:>=\(repos)")
    }
    static func repos(lessThan repos: Int) -> UserQualifier {
        return .init(rawValue: "repos:<\(repos)")
    }
    static func repos(lessThanOrEqualTo repos: Int) -> UserQualifier {
        return .init(rawValue: "repos:<=\(repos)")
    }
    static func repos(between lowerBound: Int, and upperBound: Int) -> UserQualifier {
        return .init(rawValue: "repos:\(lowerBound)..\(upperBound)")
    }
    static func repos(in range: ClosedRange<Int>) -> UserQualifier {
        return .repos(between: range.lowerBound, and: range.upperBound)
    }
    static func repos(in range: PartialRangeThrough<Int>) -> UserQualifier {
        return .repos(lessThanOrEqualTo: range.upperBound)
    }
    static func repos(in range: PartialRangeFrom<Int>) -> UserQualifier {
        return .repos(greaterThanOrEqualTo: range.lowerBound)
    }
}

// MARK: Support qualifying based on location
public extension UserQualifier {
    static func location(_ loc: String) -> UserQualifier {
        return .init(rawValue: "location:\(loc)")
    }
}

// MARK: Support qualifying based of languages of the user's owned repos
extension UserQualifier: LanguageQualifiable {}

// MARK: Support qualifying based on when the user account was created
extension UserQualifier: CreatedQualifiable {}

// MARK: Support qualifying based on the number of followers
public extension UserQualifier {
    static func followers(equals followers: Int) -> UserQualifier {
        return .init(rawValue: "followers:\(followers)")
    }
    static func followers(greaterThan followers: Int) -> UserQualifier {
        return .init(rawValue: "followers:>\(followers)")
    }
    static func followers(greaterThanOrEqualTo followers: Int) -> UserQualifier {
        return .init(rawValue: "followers:>=\(followers)")
    }
    static func followers(lessThan followers: Int) -> UserQualifier {
        return .init(rawValue: "followers:<\(followers)")
    }
    static func followers(lessThanOrEqualTo followers: Int) -> UserQualifier {
        return .init(rawValue: "followers:<=\(followers)")
    }
    static func followers(between lowerBound: Int, and upperBound: Int) -> UserQualifier {
        return .init(rawValue: "followers:\(lowerBound)..\(upperBound)")
    }
    static func followers(in range: ClosedRange<Int>) -> UserQualifier {
        return .followers(between: range.lowerBound, and: range.upperBound)
    }
    static func followers(in range: PartialRangeThrough<Int>) -> UserQualifier {
        return .followers(lessThanOrEqualTo: range.upperBound)
    }
    static func followers(in range: PartialRangeFrom<Int>) -> UserQualifier {
        return .followers(greaterThanOrEqualTo: range.lowerBound)
    }
}
