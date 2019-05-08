import struct NIOHTTP1.HTTPHeaders
import URITemplate

public final class SearchCommits: GitHubAPI {
    public typealias Response = GitHubSearchResponse<Commit>

    public enum SortOptions: String, RestfulParameter {
        case authorDate = "author-date"
        case committerDate = "committer-date"
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    static let requiredHeaders: HTTPHeaders = {
        var headers = defaultAPIHeaders
        headers.replaceOrAdd(name: "Accept", value: "application/vnd.github.cloak-preview")
        return headers
    }()

    static let endpoint: URITemplate = "/search/commits?q={+q}{&sort,order,page,perPage}"

    let connector: GitHubConnector

    init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(keywords: SearchKeyword = [],
                      qualifiers: CommitQualifier,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        let query = SearchQuery(keywords: keywords, qualifiers: qualifiers).rawValue
        return try self.query(query, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ search: SearchQuery<CommitQualifier>,
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
