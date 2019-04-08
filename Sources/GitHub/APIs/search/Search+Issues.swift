import HTTP

public typealias SearchPullRequests = SearchIssues

public final class SearchIssues: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery

    public enum SortOptions: String {
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

    public struct Response: GitHubResponse {
        public init(response: HTTPResponse) {
        }
    }

    public static let endpoint = "code"
    public static let requiresAuth = false
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ search: SearchQuery<IssueQualifier>,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Future<Response> {
        return try query(search.rawValue, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ string: String,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Future<Response> {
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
