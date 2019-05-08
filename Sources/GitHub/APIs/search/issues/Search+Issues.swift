import URITemplate

public typealias SearchPullRequests = SearchIssues

public final class SearchIssues: GitHubAPI {
    public typealias Response = GitHubSearchResponse<Issue>

    public enum SortOptions: String, RestfulParameter {
        case comments
        case reactions
        case plus1 = "reactions-+1"
        public static let thumbsUp = SortOptions.plus1
        case minus1 = "reactions--1"
        public static let thumbsDown = SortOptions.minus1
        case smile = "reactions-smile"
        case thinking = "reactions-thinking_face"
        case hearts = "reactions-heart"
        case tada = "reactions-tada"
        public static let hurray = SortOptions.tada
        case created
        case updated
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    static let endpoint: URITemplate = "/search/issues?q={+q}{&sort,order,page,perPage}"

    let connector: GitHubConnector

    init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(keywords: SearchKeyword = [],
                      qualifiers: IssueQualifier,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        let query = SearchQuery(keywords: keywords, qualifiers: qualifiers).rawValue
        return try self.query(query, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ search: SearchQuery<IssueQualifier>,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        return try query(search.rawValue, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ string: String,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        var options = [String: RestfulParameter]()
        options["q"] = string
        if order != .default {
            options["order"] = order

            // The sort parameter is ignored if the ordering is not specified
            if sort != .default {
                options["sort"] = sort
            }
        }
        options["page"] = page
        options["perPage"] = perPage

        return try get(parameters: options)
    }
}
