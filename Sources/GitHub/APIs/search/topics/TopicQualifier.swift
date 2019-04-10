public struct TopicQualifier: SearchQualifier {
    public var _qualifiers = Set<String>()

    public enum Qualifier: String {
        case curated
        case featured
        case notCurated = "not-curated"
        case notFeatured = "not-featured"
    }

    public init() {}

    public static func `is`(_ qualifier: Qualifier) -> TopicQualifier {
        return .init(rawValue: "is:\(qualifier.rawValue)")
    }
}
