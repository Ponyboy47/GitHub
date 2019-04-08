import HTTP
import NIO

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

        guard let percentEncoded = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            fatalError("Failed to percent encode '\(value)'.")
        }
        query += "\(key)=\(percentEncoded.replacingOccurrences(of: "+", with: "%2B"))"
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

    static var name: String { get }
    static var endpoint: String { get }
    static var requiresAuth: Bool { get }
    static var method: HTTPMethod { get }

    var connector: GitHubConnector { get }

    init(connector: GitHubConnector)

    func generateRequest(options: Options, page: Int?, perPage: Int?) -> HTTPRequest
}

public extension GitHubAPI {
    static var name: String { return "\(Self.self)" }

    static func buildURLPath() -> String {
        return Category.endpoint + URLPathSeparator + Self.endpoint
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

        return Category.endpoint + URLPathSeparator + Self.endpoint + query
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
        return try githubBodyDecoder.decode(Response.self, from: response.body.description)
    }
}

extension GitHubAPI where Options == HTTPBody {
    public func generateRequest(options: Options, page: Int?, perPage: Int?) -> HTTPRequest {
        return .init(method: Self.method, url: Self.buildURLPath(page: page, perPage: perPage), headers: defaultAPIHeaders, body: options)
    }
}

extension GitHubAPI where Options == URLQuery {
    public func generateRequest(options: Options, page: Int?, perPage: Int?) -> HTTPRequest {
        return .init(method: Self.method, url: options.url(base: Self.buildURLPath(), page: page, perPage: perPage), headers: defaultAPIHeaders)
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
    public let total: Int
    public let incompleteResults: Bool
    public let items: [T]
}

public protocol GitHubResponseElement: Decodable {
    var score: Double? { get }
}

public final class GitHubConnector {
    private let worker = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)

    private let auth: GitHubAuth?

    public init(auth: GitHubAuth?) {
        self.auth = auth
    }

    private func connect() -> Future<HTTPClient> {
        return HTTPClient.connect(scheme: .https, hostname: "api.github.com", on: worker)
    }

    fileprivate func send(request: HTTPRequest) -> Future<HTTPResponse> {
        return connect().flatMap(to: HTTPResponse.self) { client in
            return client.send(request)
        }
    }
}
