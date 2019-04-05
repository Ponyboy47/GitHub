import HTTP
import NIO

public var numberOfThreads = 2
public let URLPathSeparator = "/"
public let githubPerPageDefault = 30
public let githubPerPageMax = 100
public var githubPerPage = githubPerPageDefault
public let defaultAPIHeaders: HTTPHeaders = [
    "Accept": "application/vnd.github.v3+json",
    "User-Agent": "GitHubAPI-SPM-Library"
]

public protocol GitHubAPICategory: AnyObject {
    static var endpoint: String { get }

    init(connector: GitHubConnector)
}

public protocol GitHubRequestData {}

extension HTTPBody: GitHubRequestData {}
public struct URLQuery: GitHubRequestData {
    private var query: String = ""

    public mutating func add(option key: String, value: String) {
        if !query.isEmpty {
            query += "&"
        }
        query += "\(key)=\(value)"
    }

    public mutating func add<T: RawRepresentable>(option key: String, value: T) where T.RawValue == String {
        if !query.isEmpty {
            query += "&"
        }
        query += "\(key)=\(value.rawValue)"
    }

    public mutating func add(flag: String, if bool: Bool) {
        guard bool else { return }

        if !query.isEmpty {
            query += "&"
        }
        query += flag
    }

    public func url(base: String) -> String {
        return "\(base)?\(query)"
    }
}

public protocol GitHubAPI {
    associatedtype Category: GitHubAPICategory
    associatedtype Options: GitHubRequestData
    associatedtype Response: GitHubResponse

    static var name: String { get }
    static var endpoint: String { get }
    static var requiresAuth: Bool { get }
    static var method: HTTPMethod { get }

    var connector: GitHubConnector { get }

    init(connector: GitHubConnector)

    func generateRequest(options: Options) -> HTTPRequest
}

public extension GitHubAPI {
    static var name: String { return "\(Self.self)" }

    static func buildURLPath() -> String {
        return Category.endpoint + URLPathSeparator + Self.endpoint
    }

    func call(options: Options, page: Int = 1, perPage: Int = githubPerPage) throws -> Future<Response> {
        let page = page.clamped(to: 1...Int.max)
        let perPage = perPage.clamped(to: 1...githubPerPageMax)
        fatalError("Not implemented")
    }
}

extension GitHubAPI where Options == HTTPBody {
    public func generateRequest(options: Options) -> HTTPRequest {
        return .init(method: Self.method, url: Self.buildURLPath(), headers: defaultAPIHeaders, body: options)
    }
}

extension GitHubAPI where Options == URLQuery {
    public func generateRequest(options: Options) -> HTTPRequest {
        return .init(method: Self.method, url: options.url(base: Self.buildURLPath()), headers: defaultAPIHeaders)
    }
}

public protocol GitHubResponse {
    init(response: HTTPResponse)
}

public final class GitHubConnector {
    private let worker = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)

    private let auth: GitHubAuth?

    public init(auth: GitHubAuth?) {
        self.auth = auth
    }

    private func connect() throws -> HTTPClient {
        return try HTTPClient.connect(scheme: .https, hostname: "api.github.com", on: worker).wait()
    }
}

