import struct Foundation.URL

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
