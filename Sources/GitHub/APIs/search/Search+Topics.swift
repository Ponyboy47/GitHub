import HTTP

public final class SearchTopics: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Element = Topic

    public typealias SortOptions = Void

    public static let endpoint = "code"
    public static let requiresAuth = true
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ search: SearchQuery<TopicQualifier>,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        return try query(search.rawValue, page: page, perPage: perPage)
    }

    public func query(_ string: String,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        var options = Options()
        options.add(option: "q", value: string)

        return try call(options: options, page: page, perPage: perPage)
    }
}

public struct Topic: GitHubResponseElement {
    public let name: String
    public let displayName: String
    public let shortDescription: String
    public let description: String
    public let createdBy: String
    public let released: String
    public let created: Date
    public let updated: Date
    public let featured: Bool
    public let curated: Bool
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case displayName = "display_name"
        case shortDescription = "short_description"
        case description
        case createdBy = "created_by"
        case released
        case created = "created_at"
        case updated = "updated_at"
        case featured
        case curated
        case score
    }
}
