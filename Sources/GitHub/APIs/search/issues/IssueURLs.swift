import struct Foundation.URL
import URITemplate

public struct IssueURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(issue: URL, repository: URL, labels: URITemplate, comments: URL, events: URL, html: URL) {
        apis = .init(issue: issue, repository: repository, comments: comments, events: events, labels: labels)
        webpage = html
    }

    public struct APIURLs: Hashable {
        public let issue, repository, comments, events: URL
        public let labels: URITemplate
    }
}
