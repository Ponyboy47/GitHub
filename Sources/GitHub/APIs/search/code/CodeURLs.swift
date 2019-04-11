import struct Foundation.URL

public struct CodeURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(code: URL, git: URL, html: URL) {
        apis = .init(code: code, git: git)
        webpage = html
    }

    public struct APIURLs: Hashable {
        public let code: URL
        public let git: URL
    }
}
