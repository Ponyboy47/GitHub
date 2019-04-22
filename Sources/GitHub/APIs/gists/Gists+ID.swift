import URITemplate

public final class IDGist: GitHubAPI {
    public typealias Response = Gist

    public static let endpoint: URITemplate = "/gists/{gistID}{/sha}"

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ id: String, hash: String? = nil) throws -> Response {
        var options = [String: RestfulParameter]()
        options["gistID"] = id
        options["sha"] = hash
        return try get(parameters: options)
    }
}
