import struct Foundation.URL

public struct IssueURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(issue: URL, repository: URL, labels: URL, comments: URL, events: URL, html: URL) {
        apis = .init(issue: issue, repository: repository, labels: labels, comments: comments, events: events)
        webpage = html
    }

    public struct APIURLs: Hashable {
        public let issue, repository, labels, comments, events: URL
    }
}
