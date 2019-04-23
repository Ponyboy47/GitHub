import struct Foundation.URL

public struct GistCommit: GitHubResponseRepresentable, Hashable {
    public let version: String
    public let url: URL
    public let user: User
    public let changeStatus: ChangeStatus
    public let committed: GitHubDate

    enum CodingKeys: String, CodingKey {
        case version, url, user, changeStatus = "change_status", committed = "committed_at"
    }
}

public struct ChangeStatus: Decodable, Hashable {
    public let deletions: Int
    public let additions: Int
    public let total: Int
}
