import struct Foundation.Data
import struct Foundation.Date
import class Foundation.JSONEncoder
import struct Foundation.TimeInterval
import class NIO.MultiThreadedEventLoopGroup
import struct NIOHTTP1.HTTPHeaders
import enum NIOHTTP1.HTTPMethod
import class NIOHTTPClient.HTTPClient
import URITemplate

protocol GitHubAPI: RestfulAPI where BodyEncoder == JSONEncoder {
    var connector: GitHubConnector { get }

    init(connector: GitHubConnector)
}

private let jsonEncoder = JSONEncoder()
extension GitHubAPI where BodyEncoder == JSONEncoder {
    static var bodyEncoder: BodyEncoder { return jsonEncoder }
}

extension GitHubAPI {
    static var url: String { return githubURL }
    static var requiredHeaders: HTTPHeaders { return defaultAPIHeaders }

    var rateLimit: Int? { return connector.rateLimit }
    var rateLimitRemaining: Int? { return connector.rateLimitRemaining }
    var rateLimitReset: Date? { return connector.rateLimitReset }

    func call(parameters: [String: RestfulParameter], method: HTTPMethod) throws -> Future<HTTPResponse> {
        let request = try generateRequest(parameters: parameters, method: method)
        return connector.send(request: request)
    }

    func call<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter], method: HTTPMethod) throws -> R {
        let response = try call(parameters: parameters, method: method).wait()
        connector.updated(headers: response.headers)
        guard response.status == .ok else {
            fatalError("Response failed with status: \(response.status)")
        }
        guard var bytes = response.body, let data = bytes.readDispatchData(length: bytes.readableBytes) else {
            fatalError("Empty response body")
        }
        return try githubBodyDecoder.decode(R.self, from: Data(data))
    }

    func get<R: GitHubResponseRepresentable>(parameters: [String: RestfulParameter]) throws -> R {
        return try call(parameters: parameters, method: .GET)
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

final class GitHubConnector {
    private let worker = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)
    private let client: HTTPClient

    let auth: GitHubAuth?
    public private(set) var rateLimit: Int?
    public private(set) var rateLimitRemaining: Int?
    public private(set) var rateLimitReset: Date?

    public init(auth: GitHubAuth?) {
        self.auth = auth
        client = HTTPClient(eventLoopGroupProvider: .shared(worker))
    }

    func updated(headers: HTTPHeaders) {
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

        return client.execute(request: request)
    }
}

private extension HTTPHeaders {
    func firstValue(name: String) -> String? {
        return self[name].first
    }

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
