import HTTP

public final class SearchLabels: CategorizedGitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Response = GitHubSearchResponse<Label>

    public enum SortOptions: String {
        case created
        case updated
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    public static let customAcceptHeader: String? = "application/vnd.github.symmetra-preview+json"
    public static let endpoint = "labels"

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ keywords: SearchKeyword,
                      repositoryID id: Int,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        return try query(keywords.rawValue, repositoryID: id, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ string: String,
                      repositoryID id: Int,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        var options = Options()
        options.add(option: "repository_id", value: "\(id)")
        options.add(option: "q", value: string)
        if order != .default {
            options.add(option: "order", value: order)

            // The sort parameter is ignored if the ordering is not specified
            if sort != .default {
                options.add(option: "sort", value: sort)
            }
        }

        return try call(options: options, page: page, perPage: perPage)
    }
}
