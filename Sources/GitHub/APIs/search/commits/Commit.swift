import struct Foundation.URL

public struct Commit: GitHubResponseElement, Hashable {
    public let sha: String
    public let nodeID: String
    public var urls: CommitURLs {
        return CommitURLs(api: _api, html: _html, comments: _comments)
    }

    public let _api: URL
    public let _html: URL
    public let _comments: URL
    public let commit: CommitInfo
    public let author: User
    public let committer: User
    public let parents: [BasicCommit]
    public let repository: BasicRepository
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case sha
        case nodeID = "node_id"
        case _api = "url"
        case _html = "html_url"
        case _comments = "comments_url"
        case commit
        case author
        case committer
        case parents
        case repository
        case score
    }
}
