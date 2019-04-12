import struct Foundation.URL
import URITemplate

public struct UserURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(user: URL, avatar: URL, html: URL, followers: URL, following: URITemplate, gists: URITemplate, starred: URITemplate,
                subscriptions: URL, organization: URL, repos: URL, events: URITemplate, receivedEvents: URL) {
        apis = .init(user: user, avatar: avatar, followers: followers, following: following, gists: gists,
                     starred: starred, subscriptions: subscriptions, organization: organization, repos: repos,
                     events: events, receivedEvents: receivedEvents)
        webpage = html
    }

    public struct APIURLs: Hashable {
        let user: URL
        let avatar: URL
        let followers: URL
        let following: URITemplate
        let gists: URITemplate
        let starred: URITemplate
        let subscriptions: URL
        let organization: URL
        let repos: URL
        let events: URITemplate
        let receivedEvents: URL
    }
}
