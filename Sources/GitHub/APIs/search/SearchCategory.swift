public final class SearchCategory: GitHubAPICategory {
    public static var endpoint = "search"
    
    public let repositories: SearchRepositories
    public let commits: SearchCommits

    public init(connector: GitHubConnector) {
        repositories = .init(connector: connector)
        commits = .init(connector: connector)
    }
}
