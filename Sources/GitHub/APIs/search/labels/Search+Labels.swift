import struct NIOHTTP1.HTTPHeaders
import URITemplate

public final class SearchLabels: GitHubAPI {
    public typealias Response = GitHubSearchResponse<Label>

    public enum SortOptions: String, RestfulParameter {
        case created
        case updated
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    static let requiredHeaders: HTTPHeaders = {
        var headers = defaultAPIHeaders
        headers.replaceOrAdd(name: "Accept", value: "application/vnd.github.symmetra-preview+json")
        return headers
    }()

    static let endpoint: URITemplate = "/search/labels?repository_id={repository_id}&q={+q}{&sort,order,page,perPage}"

    let connector: GitHubConnector

    init(connector: GitHubConnector) {
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
        var options = [String: RestfulParameter]()
        options["repository_id"] = "\(id)"
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
