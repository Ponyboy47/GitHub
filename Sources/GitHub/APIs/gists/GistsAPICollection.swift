public final class GistsAPICollection {
    public var user: UserGists
    public var `public`: PublicGists
    public var starred: StarredGists

    public init(connector: GitHubConnector) {
        self.user = .init(connector: connector)
        self.public = .init(connector: connector)
        self.starred = .init(connector: connector)
    }
}
