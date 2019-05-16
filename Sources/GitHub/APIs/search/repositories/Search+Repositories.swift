import URITemplate

public final class SearchRepositories: GitHubAPI {
    public typealias Response = GitHubSearchResponse<Repository>

    public enum SortOptions: String, RestfulParameter {
        case stars
        case forks
        case helpWantedIssues = "help-wanted-issues"
        case updated
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    static let endpoint: URITemplate = "/search/repositories?q={+query}{&sort,order,page,per_page}"

    let connector: GitHubConnector

    init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(keywords: SearchKeyword = [],
                      qualifiers: RepositoryQualifier,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        let query = SearchQuery(keywords: keywords, qualifiers: qualifiers).rawValue
        return try self.query(query, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ search: SearchQuery<RepositoryQualifier>,
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
        options["query"] = string
        if order != .default {
            options["order"] = order

            // The sort parameter is ignored if the ordering is not specified
            if sort != .default {
                options["sort"] = sort
            }
        }
        options["page"] = page
        options["per_page"] = perPage

        return try get(parameters: options)
    }
}
