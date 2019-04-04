import HTTP

public struct GitHubAuth {
    let basic: BasicAuthentication?
    let token: TokenAuthorization?
    let secret: OAuthKeySecretAuthentication?

    public init(basic: BasicAuthentication) {
        self.basic = basic
        token = nil
        secret = nil
    }

    public init(username: String, password: String) {
        basic = .init(username: username, password: password)
        token = nil
        secret = nil
    }

    public init(token: TokenAuthorization) {
        self.token = token
        basic = nil
        secret = nil
    }

    public init(token: String) {
        self.token = TokenAuthorization(token: token)
        basic = nil
        secret = nil
    }

    public init(secret: OAuthKeySecretAuthentication) {
        self.secret = secret
        basic = nil
        token = nil
    }

    public init(key: String, secret: String) {
        self.secret = .init(key: key, secret: secret)
        basic = nil
        token = nil
    }

    public init(clientID id: String, secret: String) {
        self.init(key: id, secret: secret)
    }
}

public struct BasicAuthentication {
    let username: String
    let password: String
}

public extension GitHub {
    convenience init(basic: BasicAuthentication) {
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

public struct OAuthKeySecretAuthentication {
    let key: String
    let secret: String
}

public extension GitHub {
    convenience init(secret: OAuthKeySecretAuthentication) {
        self.init(auth: .init(secret: secret))
    }

    convenience init(key: String, secret: String) {
        self.init(auth: .init(key: key, secret: secret))
    }

    convenience init(clientID id: String, secret: String) {
        self.init(auth: .init(clientID: id, secret: secret))
    }
}
