public final class GistsAPICollection {
    private let connector: GitHubConnector

    public private(set) lazy var user = UserGists(connector: connector)
    public private(set) lazy var `public` = PublicGists(connector: connector)
    public private(set) lazy var starred = StarredGists(connector: connector)
    public private(set) lazy var id = IDGist(connector: connector)

    init(connector: GitHubConnector) {
        self.connector = connector
    }
}
