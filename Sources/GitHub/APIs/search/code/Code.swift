import struct Foundation.URL

public struct Code: GitHubResponseElement, Hashable {
    public let name: String
    public let path: String
    public let sha: String
    public var urls: CodeURLs {
        return CodeURLs(code: _api, git: _git, html: _html)
    }

    public let _api: URL
    public let _git: URL
    public let _html: URL
    public let repository: BasicRepository
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case path
        case sha
        case _api = "url"
        case _git = "git_url"
        case _html = "html_url"
        case repository
        case score
    }
}
