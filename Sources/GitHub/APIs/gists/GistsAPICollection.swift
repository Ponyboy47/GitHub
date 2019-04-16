public final class GistsAPICollection: GitHubAPICollection {
    public var user: UserGists
    public var `public`: PublicGists

    public init(connector: GitHubConnector) {
        self.user = .init(connector: connector)
        self.public = .init(connector: connector)
    }
}
