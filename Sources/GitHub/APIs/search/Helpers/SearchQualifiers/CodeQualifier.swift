public struct CodeQualifier: SearchQualifier {
    public var _qualifiers = Set<String>()

    public init() {}
}

// MARK: Support 'in:qualifier'
public extension CodeQualifier {
    enum InQualifier: String {
        case file
        case path
        case fileOrPath = "file,path"
    }

    static func `in`(_ qualifier: InQualifier) -> CodeQualifier {
        return .init(rawValue: "in:\(qualifier.rawValue)")
    }
}

// MARK: Support qualifiers for user, organization, and repository
public extension CodeQualifier {
    static func user(_ username: String) -> CodeQualifier {
        return .init(rawValue: "user:\(username)")
    }
    static func organization(_ org: String) -> CodeQualifier {
        return .init(rawValue: "organization:\(org)")
    }
    static func repository(_ repoName: String, user username: String) -> CodeQualifier {
        return .init(rawValue: "repo:\(username)/\(repoName)")
    }
    static func repo(_ repoName: String, user username: String) -> CodeQualifier {
        return .repository(repoName, user: username)
    }
}

// MARK: Support path qualifiers
public extension CodeQualifier {
    static func path(_ path: String) -> CodeQualifier {
        return .init(rawValue: "path:\(path)")
    }
}

// MARK: Support language qualifiers
public extension CodeQualifier {
    static func language(_ lang: String) -> CodeQualifier {
        return .init(rawValue: "language:\(lang)")
    }
}

// MARK: Support repository size qualifiers
public extension CodeQualifier {
    static func size(equals size: ByteSize) -> CodeQualifier {
        return .init(rawValue: "size:\(size.bytes)")
    }
    static func size(greaterThan size: ByteSize) -> CodeQualifier {
        return .init(rawValue: "size:>\(size.bytes)")
    }
    static func size(greaterThanOrEqualTo size: ByteSize) -> CodeQualifier {
        return .init(rawValue: "size:>=\(size.bytes)")
    }
    static func size(lessThan size: ByteSize) -> CodeQualifier {
        return .init(rawValue: "size:<\(size.bytes)")
    }
    static func size(lessThanOrEqualTo size: ByteSize) -> CodeQualifier {
        return .init(rawValue: "size:<=\(size.bytes)")
    }
    static func size(between lowerBound: ByteSize, and upperBound: ByteSize) -> CodeQualifier {
        return .init(rawValue: "size:\(lowerBound.bytes)..\(upperBound.bytes)")
    }
    static func size(in range: ClosedRange<ByteSize>) -> CodeQualifier {
        return .size(between: range.lowerBound, and: range.upperBound)
    }
    static func size(in range: PartialRangeThrough<ByteSize>) -> CodeQualifier {
        return .size(lessThanOrEqualTo: range.upperBound)
    }
    static func size(in range: PartialRangeFrom<ByteSize>) -> CodeQualifier {
        return .size(greaterThanOrEqualTo: range.lowerBound)
    }
}

// MARK: Support qualifiers based on the file name
public extension CodeQualifier {
    static func filename(_ name: String) -> CodeQualifier {
        return .init(rawValue: "filename:\(name)")
    }
}

// MARK: Support qualifiers based on the file extension
public extension CodeQualifier {
    static func `extension`(_ ext: String) -> CodeQualifier {
        return .init(rawValue: "extension:\(ext)")
    }
}
