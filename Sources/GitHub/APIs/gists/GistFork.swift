import struct Foundation.URL

public struct GistFork: Decodable, Hashable {
    public let user: User
    public let url: URL
    public let id: String
    public let created: GitHubDate
    public let updated: GitHubDate

    enum CodingKeys: String, CodingKey {
        case user, url, id, created = "created_at", updated = "updated_at"
    }
}
