public struct CommitUserInfo: Decodable, Hashable {
    public let date: GitHubDate
    public let name: String
    public let email: String
}
