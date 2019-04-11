import struct Foundation.URL

public struct CommitTree: Decodable, Hashable {
    public let url: URL
    public let sha: String
}
