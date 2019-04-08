import HTTP

public final class SearchUsers: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Element = User

    public enum SortOptions: String {
        case followers
        case repositories
        case joined
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    public static let endpoint = "users"
    public static let requiresAuth = false
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(keywords: SearchKeyword = [],
                      qualifiers: UserQualifier,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        let query = SearchQuery(keywords: keywords, qualifiers: qualifiers).rawValue
        return try self.query(query, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ search: SearchQuery<UserQualifier>,
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

public struct User: GitHubResponseElement {
    public enum UserType: String, Decodable {
        case user = "User"
        case organization = "Organization"
    }

    public let login: String
    public let id: Int
    public let nodeID: String
    public let url: URL
    public let gravatarID: String
    public lazy var urls: UserURLs = {
        return UserURLs(avatar: _avatar,
                        html: _html,
                        followers: _followers,
                        following: _following,
                        gists: _gists,
                        starred: _starred,
                        subscriptions: _subscriptions,
                        organization: _organizations,
                        repos: _repos,
                        events: _events,
                        receivedEvents: _receivedEvents)
    }()
    public let _avatar: URL
    public let _html: URL
    public let _followers: URL
    public let _following: String
    public let _gists: String
    public let _starred: String
    public let _subscriptions: URL
    public let _organizations: URL
    public let _repos: URL
    public let _events: String
    public let _receivedEvents: URL
    public let type: UserType
    public let siteAdmin: Bool
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeID = "node_id"
        case url
        case gravatarID = "gravatar_id"
        case _avatar = "avatar_url"
        case _html = "html_url"
        case _followers = "followers_url"
        case _following = "following_url"
        case _gists = "gists_url"
        case _starred = "starred_url"
        case _subscriptions = "subscriptions_url"
        case _organizations = "organizations_url"
        case _repos = "repos_url"
        case _events = "events_url"
        case _receivedEvents = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case score
    }
}

public struct UserURLs {
    let avatar: URL
    let html: URL
    let followers: URL
    let following: String
    let gists: String
    let starred: String
    let subscriptions: URL
    let organization: URL
    let repos: URL
    let events: String
    let receivedEvents: URL
}
