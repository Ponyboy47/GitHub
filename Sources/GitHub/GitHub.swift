import struct Foundation.Date

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
