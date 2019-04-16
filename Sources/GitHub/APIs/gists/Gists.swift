import struct Foundation.Date
import HTTP
import URITemplate

public final class GistsAPICollection: GitHubAPICollection {
    public var user: UserGists
    public var `public`: PublicGists

    public init(connector: GitHubConnector) {
        user = .init(connector: connector)
        `public` = .init(connector: connector)
    }
}

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

private var gistURLs = [Gist: GistURLs]()
public struct Gist: Decodable, Hashable {
    public let id: String
    public let nodeID: String
    public var urls: GistURLs {
        if let urls = gistURLs[self] {
            return urls
        }
        let urls = GistURLs(api: _api, forks: _forks, commits: _commits, gitPull: _gitPull, gitPush: _gitPush,
                            html: _html, comments: _comments)
        gistURLs[self] = urls
        return urls
    }

    public let _api: URL
    public let _forks: URL
    public let _commits: URL
    public let _gitPull: URL
    public let _gitPush: URL
    public let _html: URL
    public let _comments: URL
    public let files: [String: GitHubFile]
    public let `public`: Bool
    public let created: GitHubDate
    public let updated: GitHubDate
    public let description: String?
    public let comments: Int
    public let user: User?
    public let owner: User
    public let truncated: Bool

    enum CodingKeys: String, CodingKey {
        case id, nodeID = "node_id", _api = "url", _forks = "forks_url", _commits = "commits_url",
            _gitPull = "git_pull_url", _gitPush = "git_push_url", _html = "html_url", _comments = "comments_url",
            files, `public`, created = "created_at", updated = "updated_at", description, comments, user, owner,
            truncated
    }
}

public struct GistURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(api: URL, forks: URL, commits: URL, gitPull: URL, gitPush: URL, html: URL, comments: URL) {
        apis = .init(api: api, forks: forks, commits: commits, gitPull: gitPull, gitPush: gitPush, comments: comments)
        webpage = html
    }

    public struct APIURLs: Hashable {
        public let api: URL
        public let forks: URL
        public let commits: URL
        public let gitPull: URL
        public let gitPush: URL
        public let comments: URL
    }
}

public struct GitHubFile: Decodable, Hashable {
    public let filename: String
    public let type: MediaType
    public let language: String?
    public let raw: URL
    public let size: ByteSize

    enum CodingKeys: String, CodingKey {
        case filename, type, language, raw = "raw_url", size
    }
}

extension MediaType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        guard let type = MediaType.parse(stringValue) else {
            throw DecodingError.invalidMediaType(stringValue)
        }
        self = type
    }
}
