import struct Foundation.Date
import HTTP
import URITemplate

public final class UserGists: GitHubAPI {
    public typealias Response = [Gist]

    public static let endpoint: URITemplate = "/users/{username}/gists"

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ username: String, since date: Date? = nil) throws -> Response {
        var options = [String: RestfulParameter]()
        options["username"] = username.lowercased()
        if let date = date {
            options["since"] = date.iso8601
        }
        return try get(parameters: options)
    }
}
