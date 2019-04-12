public struct CodeQualifier: SearchQualifier {
    public static let sizeKey: KeyPath<ByteSize, Int> = \ByteSize.bytes

    public var _qualifiers = Set<String>()

    public init() {}
}

// MARK: Support 'in:qualifier'

extension CodeQualifier: InQualifiable {
    public enum InQualifier: String {
        case file
        case path
        case fileOrPath = "file,path"
    }
}

// MARK: Support qualifiers for user, organization, and repository

extension CodeQualifier: UserQualifiable {}
extension CodeQualifier: OrganizationQualifiable {}
extension CodeQualifier: RepositoryQualifiable {}

// MARK: Support path qualifiers

public extension CodeQualifier {
    static func path(_ path: String) -> CodeQualifier {
        return .init(rawValue: "path:\(path)")
    }
}

// MARK: Support language qualifiers

extension CodeQualifier: LanguageQualifiable {}

// MARK: Support repository size qualifiers

extension CodeQualifier: ByteSizeQualifiable {}

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
