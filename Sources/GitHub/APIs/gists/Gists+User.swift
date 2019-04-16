import struct Foundation.Date
import HTTP
import URITemplate

public final class UserGists: GitHubAPI {
    public typealias Options = URLQuery
    public typealias Response = [Gist]

    public static let endpoint: URITemplate = "users/{username}/gists"
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ username: String, since date: Date? = nil) throws -> Response {
        var options = Options()
        if let date = date {
            options.add(option: "since", value: date.iso8601)
        }
        return try call(["username": username], options: options)
    }
}
