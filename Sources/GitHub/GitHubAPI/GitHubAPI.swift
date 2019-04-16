import struct Foundation.Date
import HTTP
import NIO
import URITemplate

public protocol EndpointRepresentable {
    func stringValue(_ parameters: [String: Any]) -> String
}

extension String: EndpointRepresentable {
    public func stringValue(_: [String: Any]) -> String { return self }
}

extension URITemplate: EndpointRepresentable {
    public func stringValue(_ parameters: [String: Any]) -> String {
        return expand(parameters)
    }
}

public protocol GitHubAPICollection: AnyObject {
    init(connector: GitHubConnector)
}

public protocol GitHubAPICategory: GitHubAPICollection {
    associatedtype Endpoint: EndpointRepresentable
    static var endpoint: Endpoint { get }
}

public protocol GitHubAPI {
    associatedtype Options: GitHubRequestData
    associatedtype Response: GitHubResponseRepresentable
    associatedtype Endpoint: EndpointRepresentable = String

    static var customAcceptHeader: String? { get }
    static var name: String { get }
    static var endpoint: Endpoint { get }
    static var method: HTTPMethod { get }

    var connector: GitHubConnector { get }

    init(connector: GitHubConnector)

    func generateRequest(_ parameters: [String: Any], options: Options, page: Int?, perPage: Int?) -> HTTPRequest

    static func buildURLPath(_ parameters: [String: Any]) -> String
    static func buildURLPath(_ parameters: [String: Any], page: Int?, perPage: Int?) -> String
}

public protocol CategorizedGitHubAPI: GitHubAPI {
    associatedtype Category: GitHubAPICategory
}

public extension GitHubAPI {
    static var customAcceptHeader: String? { return nil }
    static var name: String { return "\(Self.self)" }

    var rateLimit: Int? { return connector.rateLimit }
    var rateLimitRemaining: Int? { return connector.rateLimitRemaining }
    var rateLimitReset: Date? { return connector.rateLimitReset }

    static func buildURLPath(_ parameters: [String: Any]) -> String {
        return URLPathSeparator + Self.endpoint.stringValue(parameters)
    }

    static func buildURLPath(_ parameters: [String: Any], page: Int?, perPage: Int?) -> String {
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

        return URLPathSeparator + Self.endpoint.stringValue(parameters) + query
    }

    func call(_ parameters: [String: Any] = [:],
              options: Options,
              page: Int = 1,
              perPage: Int = githubPerPage) -> Future<HTTPResponse> {
        let page = page.clamped(to: 1...Int.max)
        let perPage = perPage.clamped(to: 1...githubPerPageMax)

        let request = generateRequest(parameters,
                                      options: options,
                                      page: page == 1 ? nil : page,
                                      perPage: perPage == githubPerPage ? nil : perPage)
        return connector.send(request: request)
    }

    func call(_ parameters: [String: Any] = [:],
              options: Options,
              page: Int = 1,
              perPage: Int = githubPerPage) throws -> Response {
        let response = try call(parameters, options: options, page: page, perPage: perPage).wait()
        connector.updated(headers: response.headers)
        guard response.status == .ok else {
            fatalError("Response failed with status: \(response.status)")
        }
        return try githubBodyDecoder.decode(Response.self, from: response.body.description)
    }
}

public extension CategorizedGitHubAPI {
    static func buildURLPath(_ parameters: [String: Any]) -> String {
        return URLPathSeparator + Category.endpoint.stringValue(parameters) + URLPathSeparator + Self.endpoint.stringValue(parameters)
    }

    static func buildURLPath(_ parameters: [String: Any], page: Int?, perPage: Int?) -> String {
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

        return URLPathSeparator + Category.endpoint.stringValue(parameters) + URLPathSeparator + Self.endpoint.stringValue(parameters) + query
    }
}

extension GitHubAPI where Options == HTTPBody {
    public static var method: HTTPMethod { return .POST }
    public func generateRequest(_ parameters: [String: Any],
                                options: Options,
                                page: Int?,
                                perPage: Int?) -> HTTPRequest {
        var headers = defaultAPIHeaders
        if let accept = Self.customAcceptHeader {
            headers.replaceOrAdd(name: .accept, value: accept)
        }
        return .init(method: Self.method,
                     url: Self.buildURLPath(parameters,
                                            page: page,
                                            perPage: perPage),
                     headers: headers,
                     body: options)
    }
}

extension GitHubAPI where Options == URLQuery {
    public static var method: HTTPMethod { return .GET }
    public func generateRequest(_ parameters: [String: Any],
                                options: Options,
                                page: Int?,
                                perPage: Int?) -> HTTPRequest {
        var headers = defaultAPIHeaders
        if let accept = Self.customAcceptHeader {
            headers.replaceOrAdd(name: .accept, value: accept)
        }
        return .init(method: Self.method,
                     url: options.url(base: Self.buildURLPath(parameters),
                                      page: page,
                                      perPage: perPage),
                     headers: headers)
    }
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
            client.send(req)
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
