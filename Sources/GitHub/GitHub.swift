import struct Foundation.Date
import HTTP

public final class GitHub {
    public let connector: GitHubConnector
    public var rateLimit: Int? { return connector.rateLimit }
    public var rateLimitRemaining: Int? { return connector.rateLimitRemaining }
    public var rateLimitReset: Date? { return connector.rateLimitReset }

    public let search: SearchCategory

    public init(auth: GitHubAuth? = nil) {
        let connector = GitHubConnector(auth: auth)

        self.connector = connector
        search = .init(connector: connector)
    }
}

public struct GitHubAuth {
    let basic: BasicAuthorization?
    let token: TokenAuthorization?
    // let secret: OAuthKeySecretAuthentication?

    public init(basic: BasicAuthorization) {
        self.basic = basic
        self.token = nil
        // secret = nil
    }

    public init(username: String, password: String) {
        self.init(basic: .init(username: username, password: password))
    }

    public init(token: TokenAuthorization) {
        self.token = token
        self.basic = nil
        // secret = nil
    }

    public init(token: String) {
        self.init(token: TokenAuthorization(token: token))
    }

    // public init(secret: OAuthKeySecretAuthentication) {
    //     self.secret = secret
    //     basic = nil
    //     token = nil
    // }

    // public init(key: String, secret: String) {
    //     self.init(secret: .init(key: key, secret: secret))
    // }

    // public init(clientID id: String, secret: String) {
    //     self.init(key: id, secret: secret)
    // }
}

public extension GitHub {
    convenience init(basic: BasicAuthorization) {
        self.init(auth: .init(basic: basic))
    }

    convenience init(username: String, password: String) {
        self.init(auth: .init(username: username, password: password))
    }
}

public struct TokenAuthorization {
    let token: String
}

public extension GitHub {
    convenience init(token: TokenAuthorization) {
        self.init(auth: .init(token: token))
    }

    convenience init(token: String) {
        self.init(auth: .init(token: token))
    }
}

extension HTTPHeaders {
    var tokenAuthorization: TokenAuthorization? {
        get {
            guard let string = self[.authorization].first else { return nil }
            guard let range = string.range(of: "Token ") else { return nil }
            let token = string[range.upperBound...]
            return .init(token: String(token))
        }
        set {
            if let token = newValue {
                replaceOrAdd(name: .authorization, value: "Token \(token.token)")
            } else {
                remove(name: .authorization)
            }
        }
    }
}

// public struct OAuthKeySecretAuthentication {
//     let key: String
//     let secret: String
// }
//
// public extension GitHub {
//     convenience init(secret: OAuthKeySecretAuthentication) {
//         self.init(auth: .init(secret: secret))
//     }
//
//     convenience init(key: String, secret: String) {
//         self.init(auth: .init(key: key, secret: secret))
//     }
//
//     convenience init(clientID id: String, secret: String) {
//         self.init(auth: .init(clientID: id, secret: secret))
//     }
// }
