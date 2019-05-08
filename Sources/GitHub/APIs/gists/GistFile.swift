import struct Foundation.URL

public struct GistFile: Decodable, Hashable {
    public let filename: String
    public let type: String
    public let language: String?
    public let raw: URL
    public let size: ByteSize
    public let truncated: Bool?
    public let content: String?

    enum CodingKeys: String, CodingKey {
        case filename, type, language, raw = "raw_url", size, truncated, content
    }
}
