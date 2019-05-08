import struct Foundation.URL

public struct Gist: GitHubResponseRepresentable, Hashable {
    public let id: String
    public let nodeID: String
    public var urls: GistURLs {
        return GistURLs(api: _api, forks: _forks, commits: _commits, gitPull: _gitPull, gitPush: _gitPush,
                        html: _html, comments: _comments)
    }

    public let _api: URL
    public let _forks: URL
    public let _commits: URL
    public let _gitPull: URL
    public let _gitPush: URL
    public let _html: URL
    public let _comments: URL
    public let files: [String: GistFile]
    public let `public`: Bool
    public let created: GitHubDate
    public let updated: GitHubDate
    public let description: String?
    public let comments: Int
    public let user: User?
    public let owner: User
    public let truncated: Bool
    public let forks: [GistFork]?
    public let history: [GistCommit]?

    enum CodingKeys: String, CodingKey {
        case id, nodeID = "node_id", _api = "url", _forks = "forks_url", _commits = "commits_url",
            _gitPull = "git_pull_url", _gitPush = "git_push_url", _html = "html_url", _comments = "comments_url",
            files, `public`, created = "created_at", updated = "updated_at", description, comments, user, owner,
            truncated, forks, history
    }
}
