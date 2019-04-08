import HTTP

public final class SearchRepositories: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery

    public enum SortOptions: String {
        case stars
        case forks
        case helpWantedIssues = "help-wanted-issues"
        case updated
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    public struct Response: GitHubResponse {
        public let total: Int
        public let incompleteResults: Bool
        public let items: [Repository]

        private enum CodingKeys: String, CodingKey {
            case total = "total_count"
            case incompleteResults = "incomplete_results"
            case items
        }
    }

    public static let endpoint = "repositories"
    public static let requiresAuth = false
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
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

public struct Repository: Decodable {
    public let id: Int
    public let nodeID: String
    public let name: String
    public let fullName: String
    public let owner: User
    public let `private`: Bool
    public let htmlURL: URL
    public let description: String
    public let fork: Bool
    public let url: URL
    public let created: Date
    public let updated: Date
    public let pushed: Date
    public let homepage: URL?
    public let size: ByteSize
    public let stargazers: Int
    public let watchers: Int
    public let language: String
    public let forks: Int
    public let openIssues: Int
    public let masterBranch: String
    public let defaultBranch: String
    public let score: Double

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case owner
        case `private`
        case htmlURL = "html_url"
        case description
        case fork
        case url
        case created = "created_at"
        case updated = "updated_at"
        case pushed = "pushed_at"
        case homepage
        case size
        case stargazers = "stargazers_count"
        case watchers = "watchers_count"
        case language
        case forks = "forks_count"
        case openIssues = "open_issues_count"
        case masterBranch = "master_branch"
        case defaultBranch = "default_branch"
        case score
    }
}

public struct User: Decodable {
    public enum UserType: String, Decodable {
        case user = "User"
    }

    public let login: String
    public let id: Int
    public let nodeID: String
    public let avatar: URL
    public let gravatarID: String
    public let url: URL
    public let receivedEvents: URL
    public let type: UserType

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeID = "node_id"
        case avatar = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case receivedEvents = "received_events_url"
        case type
    }
}
