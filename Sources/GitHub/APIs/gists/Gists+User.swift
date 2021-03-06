import struct Foundation.Date
import HTTP
import URITemplate

public final class UserGists: GitHubAPI {
    public typealias Response = [Gist]

    public static let endpoint: URITemplate = "/gists{?since}"

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(since date: Date? = nil) throws -> Response {
        var options = [String: RestfulParameter]()
        if let date = date {
            options["since"] = date.iso8601
        }
        return try get(parameters: options)
    }

    public func create(_ files: [String: String]..., description: String, public: Bool = false) throws -> Response {
        return try create(files, description: description, public: `public`)
    }

    public func create(_ files: [[String: String]], description: String, public: Bool = false) throws -> Response {
        var options = [String: RestfulParameter]()
        options["files"] = try String(data: UserGists.bodyEncoder.encode(files), encoding: .utf8)
        options["description"] = description
        options["public"] = `public`

        return try post(parameters: options)
    }
}
