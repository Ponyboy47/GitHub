import struct Foundation.Date
import HTTP

public final class PublicGists: GitHubAPI {
    public typealias Options = URLQuery
    public typealias Response = [Gist]

    public static let endpoint = "gists/public"
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(since date: Date? = nil) throws -> Response {
        var options = Options()
        if let date = date {
            options.add(option: "since", value: date.iso8601)
        }
        return try call(options: options)
    }
}
