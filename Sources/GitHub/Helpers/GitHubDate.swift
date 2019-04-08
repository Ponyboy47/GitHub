import struct Foundation.Date

public struct GitHubDate: Decodable {
    public let date: Date

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        let str = try value.decode(String.self)
        guard let date = iso8601Formatter.date(from: str) else {
            throw DecodingError.invalidISO8601DateString(str)
        }

        self.date = date
    }
}

public enum DecodingError: Error {
    case invalidISO8601DateString(String)
}
