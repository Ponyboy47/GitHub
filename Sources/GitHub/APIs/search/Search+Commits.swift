import HTTP

public final class SearchCommits: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Element = Commit

    public enum SortOptions: String {
        case authorDate = "author-date"
        case committerDate = "committer-date"
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    public static let customAcceptHeader: String? = "application/vnd.github.cloak-preview"
    public static let endpoint = "commits"
    public static let requiresAuth = false
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
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

private var commitURLsCache: [Commit: CommitURLs] = [:]
public struct Commit: GitHubResponseElement, Hashable {
    public let sha: String
    public let nodeID: String
    public var urls: CommitURLs {
        if let urls = commitURLsCache[self] {
            return urls
        }
        let urls = CommitURLs(api: _api,
                              html: _html,
                              comments: _comments)
        commitURLsCache[self] = urls
        return urls
    }
    public let _api: URL
    public let _html: URL
    public let _comments: URL
    public let commit: CommitInfo
    public let author: User
    public let committer: User
    public let parents: [BasicCommit]
    public let repository: Repository
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case sha
        case nodeID = "node_id"
        case _api = "url"
        case _html = "html_url"
        case _comments = "comments_url"
        case commit
        case author
        case committer
        case parents
        case repository
        case score
    }
}

public struct CommitURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    init(api: URL, html: URL, comments: URL) {
        apis = .init(commit: api, comments: comments)
        webpage = html
    }

    public struct APIURLs: Hashable {
        public let commit: URL
        public let comments: URL
    }
}

public struct CommitInfo: Decodable, Hashable {
    public let url: URL
    public let author: CommitUserInfo
    public let committer: CommitUserInfo
    public let message: String
    public let tree: CommitTree
    public let comments: Int

    enum CodingKeys: String, CodingKey {
        case url
        case author
        case committer
        case message
        case tree
        case comments = "comment_count"
    }
}

public struct CommitUserInfo: Decodable, Hashable {
    public let date: GitHubDate
    public let name: String
    public let email: String
}

public struct CommitTree: Decodable, Hashable {
    public let url: URL
    public let sha: String
}

public struct BasicCommit: Decodable, Hashable {
    public let url: URL
    public let html: URL
    public let sha: String

    enum CodingKeys: String, CodingKey {
        case url
        case html = "html_url"
        case sha
    }
}
