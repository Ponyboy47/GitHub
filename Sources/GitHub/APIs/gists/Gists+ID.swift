import URITemplate

public final class IDGist: GitHubAPI {
    public static let endpoint: URITemplate = "/gists/{gistID}{/sha,commits}"

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func get(_ id: String, hash: String? = nil) throws -> Gist {
        var options = [String: RestfulParameter]()
        options["gistID"] = id
        options["sha"] = hash
        return try get(parameters: options)
    }

    public func commits(_ id: String) throws -> [GistCommit] {
        var options = [String: RestfulParameter]()
        options["gistID"] = id
        options["commits"] = "commits"
        return try get(parameters: options)
    }
}
