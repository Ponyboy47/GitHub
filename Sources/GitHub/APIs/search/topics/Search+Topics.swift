import HTTP

public final class SearchTopics: CategorizedGitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Response = GitHubSearchResponse<Topic>

    public typealias SortOptions = Void

    public static let customAcceptHeader: String? = "application/vnd.github.mercy-preview+json"
    public static let endpoint = "topics"

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(keywords: SearchKeyword = [],
                      qualifiers: TopicQualifier,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        let query = SearchQuery(keywords: keywords, qualifiers: qualifiers).rawValue
        return try self.query(query, page: page, perPage: perPage)
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
