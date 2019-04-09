public final class SearchCategory: GitHubAPICategory {
    public static var endpoint = "search"
    
    public let repositories: SearchRepositories
    public let commits: SearchCommits
    public let code: SearchCode
    public let issues: SearchIssues
    public let users: SearchUsers
    public let topics: SearchTopics
    public let labels: SearchLabels

    public init(connector: GitHubConnector) {
        repositories = .init(connector: connector)
        commits = .init(connector: connector)
        code = .init(connector: connector)
        issues = .init(connector: connector)
        users = .init(connector: connector)
        topics = .init(connector: connector)
        labels = .init(connector: connector)
    }
}
