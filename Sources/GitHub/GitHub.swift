public final class GitHub {
    public let search: SearchCategory

    public init(auth: GitHubAuth? = nil) {
        let connector = GitHubConnector(auth: auth)

        search = .init(connector: connector)
    }
}
