import HTTP
import NIO
import struct Foundation.Date

public var numberOfThreads = System.coreCount
public let URLPathSeparator = "/"
public let githubPerPageDefault = 30
public let githubPerPageMax = 100
public var githubPerPage = githubPerPageDefault
public let githubBodyDecoder = JSONDecoder()
public let defaultAPIHeaders: HTTPHeaders = [
    "Accept": "application/vnd.github.v3+json",
    "User-Agent": "GitHubAPI-SPM-Library"
]
public let githubRateLimitHeader = HTTPHeaderName("X-RateLimit-Limit")
public let githubRateLimitRemainingHeader = HTTPHeaderName("X-RateLimit-Remaining")
public let githubRateLimitResetHeader = HTTPHeaderName("X-RateLimit-Reset")

public protocol GitHubAPICategory: AnyObject {
    static var endpoint: String { get }

    init(connector: GitHubConnector)
}

public protocol GitHubRequestData {}

extension HTTPBody: GitHubRequestData {}
public struct URLQuery: GitHubRequestData {
    private var query: String = ""

    public mutating func add<T: RawRepresentable>(option key: String, value: T) where T.RawValue == String {
        add(option: key, value: value.rawValue)
    }

    public mutating func add(option key: String, value: String) {
        if !query.isEmpty {
            query += "&"
        }

        query += "\(key)=\(value)"
    }

    public mutating func add(flag: String, if bool: Bool) {
        guard bool else { return }

        if !query.isEmpty {
            query += "&"
        }
        query += flag
    }

    func url(base: String, page: Int?, perPage: Int?) -> String {
        var paging = ""
        if (page != nil || perPage != nil) && !query.isEmpty {
            paging += "&"
        }

        if let page = page {
            paging += "page=\(page)"
        }
        if let perPage = perPage {
            if paging.count > 1 {
                paging += "&"
            }
            paging += "per_page=\(perPage)"
        }

        if !query.isEmpty {
            return "\(base)?\(query)\(paging)"
        } else if !paging.isEmpty {
            return "\(base)?\(paging)"
        }
        return base
    }
}

public protocol GitHubAPI {
    associatedtype Category: GitHubAPICategory
    associatedtype Options: GitHubRequestData
    associatedtype Element: GitHubResponseElement
    associatedtype Response: GitHubResponseRepresentable = GitHubResponse<Element>

    static var customAcceptHeader: String? { get }
    static var name: String { get }
    static var endpoint: String { get }
    static var method: HTTPMethod { get }

    var connector: GitHubConnector { get }

    init(connector: GitHubConnector)

    func generateRequest(options: Options, page: Int?, perPage: Int?) -> HTTPRequest
}

public extension GitHubAPI {
    static var customAcceptHeader: String? { return nil }
    static var name: String { return "\(Self.self)" }

    var rateLimit: Int? { return connector.rateLimit }
    var rateLimitRemaining: Int? { return connector.rateLimitRemaining }
    var rateLimitReset: Date? { return connector.rateLimitReset }

    static func buildURLPath() -> String {
        return URLPathSeparator + Category.endpoint + URLPathSeparator + Self.endpoint
    }
    static func buildURLPath(page: Int?, perPage: Int?) -> String {
        var query = ""
        if page != nil || perPage != nil {
            query += "?"
        }

        if let page = page {
            query += "page=\(page)"
        }
        if let perPage = perPage {
            if query.count > 1 {
                query += "&"
            }
            query += "per_page=\(perPage)"
        }

        return URLPathSeparator + Category.endpoint + URLPathSeparator + Self.endpoint + query
    }

    func call(options: Options, page: Int = 1, perPage: Int = githubPerPage) -> Future<HTTPResponse> {
        let page = page.clamped(to: 1...Int.max)
        let perPage = perPage.clamped(to: 1...githubPerPageMax)

        let request = generateRequest(options: options,
                                      page: page == 1 ? nil : page,
                                      perPage: perPage == githubPerPage ? nil : perPage)
        return connector.send(request: request)
    }

    func call(options: Options, page: Int = 1, perPage: Int = githubPerPage) throws -> Response {
        let response = try call(options: options, page: page, perPage: perPage).wait()
        connector.updated(headers: response.headers)
        guard response.status == .ok else {
            print(response.status)
            fatalError("Response failed with status: \(response.status)")
        }
        return try githubBodyDecoder.decode(Response.self, from: response.body.description)
    }
}

extension GitHubAPI where Options == HTTPBody {
    public static var method: HTTPMethod { return .POST }
    public func generateRequest(options: Options, page: Int?, perPage: Int?) -> HTTPRequest {
        var headers = defaultAPIHeaders
        if let accept = Self.customAcceptHeader {
            headers.replaceOrAdd(name: .accept, value: accept)
        }
        return .init(method: Self.method, url: Self.buildURLPath(page: page, perPage: perPage), headers: headers, body: options)
    }
}

extension GitHubAPI where Options == URLQuery {
    public static var method: HTTPMethod { return .GET }
    public func generateRequest(options: Options, page: Int?, perPage: Int?) -> HTTPRequest {
        var headers = defaultAPIHeaders
        if let accept = Self.customAcceptHeader {
            headers.replaceOrAdd(name: .accept, value: accept)
        }
        return .init(method: Self.method, url: options.url(base: Self.buildURLPath(), page: page, perPage: perPage), headers: headers)
    }
}

public protocol GitHubResponseRepresentable: Decodable {
    associatedtype Element: Decodable

    var total: Int { get }
    var incompleteResults: Bool { get }
    var items: [Element] { get }
}
public enum GitHubResponseKeys: String, CodingKey {
    case total = "total_count"
    case incompleteResults = "incomplete_results"
    case items
}
public extension GitHubResponseRepresentable {
    typealias CodingKeys = GitHubResponseKeys
}
public struct GitHubResponse<T: Decodable>: GitHubResponseRepresentable {
    public typealias CodingKeys = GitHubResponseKeys

    public let total: Int
    public let incompleteResults: Bool
    public let items: [T]
}

public protocol GitHubResponseElement: Decodable {
    associatedtype URLsContainer: GitHubURLContainer = Empty
    var urls: URLsContainer { get }
    var score: Double? { get }
}
public extension GitHubResponseElement where URLsContainer == Empty {
    var urls: Empty { return Empty() }
}

public protocol GitHubURLContainer {
    associatedtype APIURLs
    associatedtype WebPageURL = URL
    associatedtype OtherURLs = Void

    var apis: APIURLs { get }
    var webpage: WebPageURL { get }
    var others: OtherURLs { get }
}
public extension GitHubURLContainer where OtherURLs == Void {
    var others: Void { return () }
}

public struct Empty: GitHubURLContainer {
    public let apis: Void = ()
    public let webpage: Void = ()

    public init() {}
}

public final class GitHubConnector {
    private let worker = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)

    private let auth: GitHubAuth?
    public private(set) var rateLimit: Int?
    public private(set) var rateLimitRemaining: Int?
    public private(set) var rateLimitReset: Date?

    public init(auth: GitHubAuth?) {
        self.auth = auth
    }

    private func connect() -> Future<HTTPClient> {
        return HTTPClient.connect(scheme: .https, hostname: "api.github.com", on: worker)
    }

    fileprivate func updated(headers: HTTPHeaders) {
        rateLimit = headers.rateLimit
        rateLimitRemaining = headers.rateLimitRemaining
        rateLimitReset = headers.rateLimitReset
    }

    fileprivate func send(request: HTTPRequest) -> Future<HTTPResponse> {
        var req = request
        if let auth = auth {
            if let basic = auth.basic {
                req.headers.basicAuthorization = basic
            } else if let token = auth.token {
                req.headers.tokenAuthorization = token
            }
        }

        return connect().flatMap(to: HTTPResponse.self) { client in
            return client.send(req)
        }
    }
}

private extension HTTPHeaders {
    var rateLimit: Int? {
        guard let value = firstValue(name: githubRateLimitHeader) else { return nil }
        return Int(value)
    }

    var rateLimitRemaining: Int? {
        guard let value = firstValue(name: githubRateLimitRemainingHeader) else { return nil }
        return Int(value)
    }

    var rateLimitReset: Date? {
        guard let value = firstValue(name: githubRateLimitResetHeader) else { return nil }
        guard let reset = TimeInterval(value) else { return nil }
        return .init(timeIntervalSince1970: reset)
    }
}
