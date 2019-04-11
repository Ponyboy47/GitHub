import struct Foundation.URL

public struct BasicCommit: Decodable, Hashable {
    public let url: URL
    public let html: URL
    public let sha: String

    enum CodingKeys: String, CodingKey {
        case url
        case html = "html_url"
        case sha
    }
}
