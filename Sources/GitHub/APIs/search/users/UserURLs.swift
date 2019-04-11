import struct Foundation.URL

public struct UserURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(user: URL, avatar: URL, html: URL, followers: URL, following: String, gists: String, starred: String,
                subscriptions: URL, organization: URL, repos: URL, events: String, receivedEvents: URL) {
        apis = .init(user: user, avatar: avatar, followers: followers, following: following, gists: gists,
                     starred: starred, subscriptions: subscriptions, organization: organization, repos: repos,
                     events: events, receivedEvents: receivedEvents)
        webpage = html
    }

    public struct APIURLs: Hashable {
        let user: URL
        let avatar: URL
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
}
