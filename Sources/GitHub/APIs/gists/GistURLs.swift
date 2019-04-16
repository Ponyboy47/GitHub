import struct Foundation.URL

public struct GistURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(api: URL, forks: URL, commits: URL, gitPull: URL, gitPush: URL, html: URL, comments: URL) {
        apis = .init(api: api, forks: forks, commits: commits, gitPull: gitPull, gitPush: gitPush, comments: comments)
        webpage = html
    }

    public struct APIURLs: Hashable {
        public let api: URL
        public let forks: URL
        public let commits: URL
        public let gitPull: URL
        public let gitPush: URL
        public let comments: URL
    }
}
