import HTTP
import NIO

public var numberOfThreads = 2
public let URLPathSeparator = "/"
public let defaultAPIHeaders: HTTPHeaders = [
    "Accept": "application/vnd.github.v3+json",
    "User-Agent": "GitHubAPI-SPM-Library"
]

public protocol GitHubAPICategory: AnyObject {
    static var endpoint: String { get }

    init(connector: GitHubConnector)
}

public protocol HTTPRequestRepresentable {
    static var isBody: Bool { get }
    func stringRepresentation() -> String
}

public protocol GitHubAPI {
    associatedtype Category: GitHubAPICategory
    associatedtype Options: HTTPRequestRepresentable

    static var name: String { get }
    static var endpoint: String { get }
    static var requiresAuth: Bool { get }
    static var method: HTTPMethod { get }

    var connector: GitHubConnector { get }

    init(connector: GitHubConnector)
}

public extension GitHubAPI {
    public static var name: String { return "\(Self.self)" }

    public static func buildURLPath() -> String {
        return Category.endpoint + URLPathSeparator + Self.endpoint
    }

    public static func call(options: Options, page: Int = 1, perPage: Int = 30) throws -> Future<GitHubResponse> {
        let page = page.clamped(to: 1...Int.max)
        let perPage = perPage.clamped(to: 1...100)
        fatalError("Not implemented")
    }
}

public final class GitHubResponse: HTTPMessage {
    public var method: HTTPMethod = .GET
    public var version = HTTPVersion(major: 2, minor: 0)
    public var headers: HTTPHeaders = ["Accept": "application/vnd.github.v3+json"]
    public var body: HTTPBody = .empty
    public var channel: Channel? = nil
    public var description: String {
        return "\(type(of: self))()"
    }

    public init() {}
}

public final class GitHubConnector {
    private static let worker = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)

    private let auth: GitHubAuth?

    public init(auth: GitHubAuth?) {
        self.auth = auth
    }

    private static func connect() throws -> HTTPClient {
        return try HTTPClient.connect(scheme: .https, hostname: "api.github.com", on: worker).wait()
    }
}

