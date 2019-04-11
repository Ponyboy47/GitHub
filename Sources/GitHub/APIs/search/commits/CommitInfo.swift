import struct Foundation.URL

public struct CommitInfo: Decodable, Hashable {
    public let url: URL
    public let author: CommitUserInfo
    public let committer: CommitUserInfo
    public let message: String
    public let tree: CommitTree
    public let comments: Int

    enum CodingKeys: String, CodingKey {
        case url
        case author
        case committer
        case message
        case tree
        case comments = "comment_count"
    }
}
