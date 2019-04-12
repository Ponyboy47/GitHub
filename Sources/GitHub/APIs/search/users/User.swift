import struct Foundation.URL
import URITemplate

public struct User: GitHubResponseElement, Hashable {
    public enum UserType: String, Decodable {
        case user = "User"
        case organization = "Organization"
    }

    public let login: String
    public let id: Int
    public let nodeID: String
    public let gravatarID: String
    public lazy var urls: UserURLs = {
        UserURLs(user: _api, avatar: _avatar, html: _html, followers: _followers, following: _following,
                 gists: _gists, starred: _starred, subscriptions: _subscriptions, organization: _organizations,
                 repos: _repos, events: _events, receivedEvents: _receivedEvents)
    }()

    public let _api, _avatar, _html, _followers, _subscriptions, _organizations, _repos, _receivedEvents: URL
    public let _following, _gists, _starred, _events: URITemplate
    public let type: UserType
    public let siteAdmin: Bool
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case login, id, nodeID = "node_id", gravatarID = "gravatar_id", _api = "url", _avatar = "avatar_url",
            _html = "html_url", _followers = "followers_url", _following = "following_url", _gists = "gists_url",
            _starred = "starred_url", _subscriptions = "subscriptions_url", _organizations = "organizations_url",
            _repos = "repos_url", _events = "events_url", _receivedEvents = "received_events_url", type,
            siteAdmin = "site_admin", score
    }
}
