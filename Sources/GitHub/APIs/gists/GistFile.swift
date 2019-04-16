import HTTP

public struct GistFile: Decodable, Hashable {
    public let filename: String
    public let type: MediaType
    public let language: String?
    public let raw: URL
    public let size: ByteSize

    enum CodingKeys: String, CodingKey {
        case filename, type, language, raw = "raw_url", size
    }
}

extension MediaType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        guard let type = MediaType.parse(stringValue) else {
            throw DecodingError.invalidMediaType(stringValue)
        }
        self = type
    }
}
