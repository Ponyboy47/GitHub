public final class SearchCategory: GitHubAPICategory {
    public static var endpoint = "search"
    
    public let repositories: SearchRepositories

    public init(connector: GitHubConnector) {
        repositories = .init(connector: connector)
    }
}
