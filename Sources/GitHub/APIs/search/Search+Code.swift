import HTTP

public final class SearchCode: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery

    public enum SortOptions: String {
        case indexed
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    public struct Response: GitHubResponse {
    }

    public static let endpoint = "code"
    public static let requiresAuth = true
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ search: SearchQuery<CodeQualifier>,
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
        var options = Options()
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
