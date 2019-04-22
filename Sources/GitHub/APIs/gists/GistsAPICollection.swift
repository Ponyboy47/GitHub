public final class GistsAPICollection {
    public var user: UserGists
    public var `public`: PublicGists
    public var starred: StarredGists
    public var id: IDGist

    public init(connector: GitHubConnector) {
        self.user = .init(connector: connector)
        self.public = .init(connector: connector)
        self.starred = .init(connector: connector)
        self.id = .init(connector: connector)
    }
}
