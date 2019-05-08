import struct Foundation.Date
import URITemplate

public final class UsersGists: GitHubAPI {
    public typealias Response = [Gist]

    static let endpoint: URITemplate = "/users/{username}/gists"

    let connector: GitHubConnector

    init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ username: String, since date: Date? = nil) throws -> Response {
        var options = [String: RestfulParameter]()
        options["username"] = username
        if let date = date {
            options["since"] = date.iso8601
        }
        return try get(parameters: options)
    }
}
