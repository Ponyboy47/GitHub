import struct Foundation.Date
import class Foundation.ISO8601DateFormatter
import class Foundation.DateFormatter
import struct Foundation.Locale

let ISO8601Formatter = ISO8601DateFormatter()
let AlternateISO8601Formatter: DateFormatter = {
    let fmtr: DateFormatter = DateFormatter()
    fmtr.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    fmtr.locale = Locale(identifier: "en_US_POSIX")
    fmtr.timeZone = ISO8601Formatter.timeZone
    return fmtr
}()


public struct GitHubDate: Decodable, Hashable {
    public let date: Date

    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        let str = try value.decode(String.self)
        if let date = ISO8601Formatter.date(from: str) {
            self.date = date
        } else if let date = AlternateISO8601Formatter.date(from: str) {
            self.date = date
        } else {
            throw DecodingError.invalidISO8601DateString(str)
        }
    }
}

public enum DecodingError: Error {
    case invalidISO8601DateString(String)
}
