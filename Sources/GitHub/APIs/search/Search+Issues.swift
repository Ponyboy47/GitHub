import HTTP

public typealias SearchPullRequests = SearchIssues

public final class SearchIssues: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Element = Issue

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

    public static let endpoint = "code"
    public static let requiresAuth = false
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
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

public struct Issue: GitHubResponseElement {
    public let url: URL
    public lazy var urls: IssueURLs = {
        return IssueURLs(repository: _repository,
                         labels: _labels,
                         comments: _comments,
                         events: _events,
                         html: _html)
    }()
    public let _repository: URL
    public let _labels: URL
    public let _comments: URL
    public let _events: URL
    public let _html: URL
    public let id: Int
    public let nodeID: String
    public let number: Int
    public let title: String
    public let user: User
    public let labels: [Label]
    public let state: IssueState
    public let assignee: User?
    public let milestone: String?
    public let comments: Int
    public let created: GitHubDate
    public let updated: GitHubDate
    public let closed: GitHubDate
    public let pullRequest: PullRequest
    public let body: String
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case url
        case _repository = "repository_url"
        case _labels = "labels_url"
        case _comments = "comments_url"
        case _events = "events_url"
        case _html = "html_url"
        case id
        case nodeID = "node_id"
        case number
        case title
        case user
        case labels
        case state
        case assignee
        case milestone
        case comments = "comments_count"
        case created = "created_at"
        case updated = "updated_at"
        case closed = "closed_at"
        case pullRequest = "pull_request"
        case body
        case score
    }
}

public struct IssueURLs {
    public let repository: URL
    public let labels: URL
    public let comments: URL
    public let events: URL
    public let html: URL
}

public struct PullRequest: Decodable {
    public let html: URL
    public let diff: URL
    public let patch: URL

    enum CodingKeys: String, CodingKey {
        case html = "html_url"
        case diff = "diff_url"
        case patch = "patch_url"
    }
}
