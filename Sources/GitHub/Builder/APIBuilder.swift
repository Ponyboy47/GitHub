import HTTP
import URITemplate

public protocol RestfulAPI {
    associatedtype BodyEncoder: DataEncoder
    static var bodyEncoder: BodyEncoder { get }
    static var endpoint: URITemplate { get }
    static var requiredHeaders: HTTPHeaders { get }
    func call(parameters: [String: RestfulParameter], method: HTTPMethod) -> Future<HTTPResponse>
}

public extension RestfulAPI {
    func generateRequest(parameters: [String: RestfulParameter], method: HTTPMethod) -> HTTPRequest {
        var data = parameters
        if let page = data["page"] as? Int, page <= 1 {
            data.removeValue(forKey: "page")
        }
        if let perPage = data["perPage"] as? Int {
            if perPage == githubPerPage {
                data.removeValue(forKey: "perPage")
            } else if perPage < 1 {
                data["perPage"] = 1
            } else if perPage > githubPerPageMax {
                data["perPage"] = githubPerPageMax
            }
        }
        let url = Self.endpoint.expand(data)

        var headers = defaultAPIHeaders
        for header in Self.requiredHeaders {
            headers.replaceOrAdd(name: header.name, value: header.value)
        }

        switch method {
        case .HEAD, .GET: return .init(method: method,
                                       url: url,
                                       headers: headers)
        default:
            let encodable: [String: String] = .init(uniqueKeysWithValues: data.map { ($0.0, $0.1.stringValue) })
            let encoded = try! Self.bodyEncoder.encode(encodable)
            return .init(method: method,
                         url: url,
                         headers: headers,
                         body: HTTPBody(data: encoded))
        }
    }
}

extension RestfulAPI {
    func get(parameters: [String: RestfulParameter]) -> Future<HTTPResponse> {
        return call(parameters: parameters, method: .GET)
    }

    func head(parameters: [String: RestfulParameter]) -> Future<HTTPResponse> {
        return call(parameters: parameters, method: .HEAD)
    }

    func post(parameters: [String: RestfulParameter]) -> Future<HTTPResponse> {
        return call(parameters: parameters, method: .POST)
    }

    func put(parameters: [String: RestfulParameter]) -> Future<HTTPResponse> {
        return call(parameters: parameters, method: .PUT)
    }

    func patch(parameters: [String: RestfulParameter]) -> Future<HTTPResponse> {
        return call(parameters: parameters, method: .PATCH)
    }

    func delete(parameters: [String: RestfulParameter]) -> Future<HTTPResponse> {
        return call(parameters: parameters, method: .DELETE)
    }
}

public protocol RestfulParameter {
    var stringValue: String { get }
}

extension RestfulParameter where Self: RawRepresentable, RawValue == String {
    public var stringValue: String { return rawValue }
}

extension Bool: RestfulParameter {
    public var stringValue: String { return "\(self)" }
}

extension String: RestfulParameter {
    public var stringValue: String { return self }
}

extension Int: RestfulParameter {
    public var stringValue: String { return "\(self)" }
}

extension Double: RestfulParameter {
    public var stringValue: String { return "\(self)" }
}

extension Array: RestfulParameter where Element: RestfulParameter {
    public var stringValue: String {
        return map { $0.stringValue }.joined(separator: ",")
    }
}

public protocol DataEncoder {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: DataEncoder {}
