import HTTP

public final class SearchTopics: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery

    public typealias SortOptions = Void

    public struct Response: GitHubResponse {
        public init(response: HTTPResponse) {
        }
    }

    public static let endpoint = "code"
    public static let requiresAuth = true
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ search: SearchQuery<TopicQualifier>,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Future<Response> {
        return try query(search.rawValue, page: page, perPage: perPage)
    }

    public func query(_ string: String,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Future<Response> {
        var options = Options()
        options.add(option: "q", value: string)

        return try call(options: options, page: page, perPage: perPage)
    }
}
