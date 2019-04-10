import HTTP

public final class SearchLabels: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Element = Label

    public enum SortOptions: String {
        case created
        case updated
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    public static let endpoint = "lables"
    public static let requiresAuth = false
    public static let method: HTTPMethod = .GET

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

public struct Label: GitHubResponseElement {
    public let id: Int
    public let nodeID: String
    public let url: URL
    public let name: String
    public let color: String
    public let `default`: Bool
    public let description: String
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case url
        case name
        case color
        case `default`
        case description
        case score
    }
}
