import struct Foundation.Date
import HTTP
import NIO
import URITemplate

public protocol GitHubAPI: RestfulAPI where BodyEncoder == JSONEncoder {
    var connector: GitHubConnector { get }

    init(connector: GitHubConnector)
}

private let jsonEncoder = JSONEncoder()
public extension GitHubAPI where BodyEncoder == JSONEncoder {
    static var bodyEncoder: BodyEncoder { return jsonEncoder }
}

public extension GitHubAPI {
    static var requiredHeaders: HTTPHeaders { return defaultAPIHeaders }

    var rateLimit: Int? { return connector.rateLimit }
    var rateLimitRemaining: Int? { return connector.rateLimitRemaining }
    var rateLimitReset: Date? { return connector.rateLimitReset }

    func call(parameters: [String: RestfulParameter], method: HTTPMethod) -> Future<HTTPResponse> {
        let request = generateRequest(parameters: parameters, method: method)
        return connector.send(request: request)
    }

    func call<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter], method: HTTPMethod) throws -> R {
        let response = try call(parameters: parameters, method: method).wait()
        connector.updated(headers: response.headers)
        guard response.status == .ok else {
            fatalError("Response failed with status: \(response.status)")
        }
        return try githubBodyDecoder.decode(R.self, from: response.body.description)
    }

    func get<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter]) throws -> R {
        return try call(parameters: parameters, method: .GET)
    }

    func head<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter]) throws -> R {
        return try call(parameters: parameters, method: .HEAD)
    }

    func post<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter]) throws -> R {
        return try call(parameters: parameters, method: .POST)
    }

    func put<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter]) throws -> R {
        return try call(parameters: parameters, method: .PUT)
    }

    func patch<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter]) throws -> R {
        return try call(parameters: parameters, method: .PATCH)
    }

    func delete<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter]) throws -> R {
        return try call(parameters: parameters, method: .DELETE)
    }
}

public final class GitHubConnector {
    private let worker = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)

    let auth: GitHubAuth?
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
