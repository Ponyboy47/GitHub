import URITemplate

public final class IDGist: GitHubAPI {
    public static let endpoint: URITemplate = "/gists/{gistID}{/sha,commits,star}"

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

    public func edit(_ id: String, files: [String: FileEdit?]..., description: String) throws -> Gist {
        return try edit(id, files: files, description: description)
    }

    public func edit(_ id: String, files: [[String: FileEdit?]], description: String) throws -> Gist {
        var options = [String: RestfulParameter]()
        options["gistID"] = id
        options["files"] = try String(data: UserGists.bodyEncoder.encode(files), encoding: .utf8)
        options["description"] = description

        return try patch(parameters: options)
    }

    public func star(_ id: String) throws {
        var options = [String: RestfulParameter]()
        options["gistID"] = id
        options["star"] = "star"

        let response = try put(parameters: options).wait()
        connector.updated(headers: response.headers)
        guard response.status == .noContent else {
            throw GitHubAPIError.failedToStar
        }
    }
}
