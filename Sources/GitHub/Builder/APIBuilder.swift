import struct Foundation.Data
import class Foundation.JSONEncoder
import struct NIOHTTP1.HTTPHeaders
import enum NIOHTTP1.HTTPMethod
import class NIOHTTPClient.HTTPClient
import URITemplate

protocol RestfulAPI {
    associatedtype BodyEncoder: DataEncoder
    static var bodyEncoder: BodyEncoder { get }
    static var url: String { get }
    static var endpoint: URITemplate { get }
    static var requiredHeaders: HTTPHeaders { get }
    func call(parameters: [String: RestfulParameter], method: HTTPMethod) throws -> Future<HTTPResponse>
}

extension RestfulAPI {
    func generateRequest(parameters: [String: RestfulParameter], method: HTTPMethod) throws -> HTTPRequest {
        var data = parameters
        if let page = data["page"] as? Int, page <= 1 {
            data.removeValue(forKey: "page")
        }
        if let perPage = data["per_page"] as? Int {
            if perPage == githubPerPage {
                data.removeValue(forKey: "per_page")
            } else if perPage < 1 {
                data["per_page"] = 1
            } else if perPage > githubPerPageMax {
                data["per_page"] = githubPerPageMax
            }
        }
        let url = "\(Self.url)\(Self.endpoint.expand(data))"

        var headers = defaultAPIHeaders
        for header in Self.requiredHeaders {
            headers.replaceOrAdd(name: header.name, value: header.value)
        }

        switch method {
        case .HEAD, .GET:
            return try .init(url: url,
                             method: method,
                             headers: headers)
        default:
            let encodable: [String: String] = .init(uniqueKeysWithValues: data.map { ($0.0, $0.1.stringValue) })
            let encoded = try! Self.bodyEncoder.encode(encodable)
            return try .init(url: url,
                             method: method,
                             headers: headers,
                             body: HTTPClient.Body.data(encoded))
        }
    }
}

extension RestfulAPI {
    func get(parameters: [String: RestfulParameter]) throws -> Future<HTTPResponse> {
        return try call(parameters: parameters, method: .GET)
    }

    func post(parameters: [String: RestfulParameter]) throws -> Future<HTTPResponse> {
        return try call(parameters: parameters, method: .POST)
    }

    func put(parameters: [String: RestfulParameter]) throws -> Future<HTTPResponse> {
        return try call(parameters: parameters, method: .PUT)
    }

    func patch(parameters: [String: RestfulParameter]) throws -> Future<HTTPResponse> {
        return try call(parameters: parameters, method: .PATCH)
    }

    func delete(parameters: [String: RestfulParameter]) throws -> Future<HTTPResponse> {
        return try call(parameters: parameters, method: .DELETE)
    }
}

protocol RestfulParameter {
    var stringValue: String { get }
}

extension RestfulParameter where Self: RawRepresentable, RawValue == String {
    var stringValue: String { return rawValue }
}

extension Bool: RestfulParameter {
    var stringValue: String { return "\(self)" }
}

extension String: RestfulParameter {
    var stringValue: String { return self }
}

extension Int: RestfulParameter {
    var stringValue: String { return "\(self)" }
}

extension Double: RestfulParameter {
    var stringValue: String { return "\(self)" }
}

extension Array: RestfulParameter where Element: RestfulParameter {
    var stringValue: String {
        return map { $0.stringValue }.joined(separator: ",")
    }
}

public protocol DataEncoder {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: DataEncoder {}
