import struct Foundation.Date
import URITemplate

public final class PublicGists: GitHubAPI {
    public typealias Response = [Gist]

    static let endpoint: URITemplate = "/gists/public{?since}"

    let connector: GitHubConnector

    init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(since date: Date? = nil) throws -> Response {
        var options = [String: RestfulParameter]()
        if let date = date {
            options["since"] = date.iso8601
        }
        return try get(parameters: options)
    }
}
