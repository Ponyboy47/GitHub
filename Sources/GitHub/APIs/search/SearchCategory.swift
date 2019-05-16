import struct Foundation.Date

public final class SearchCategory {
    private let connector: GitHubConnector

    public private(set) lazy var repositories = SearchRepositories(connector: connector)
    public private(set) lazy var commits = SearchCommits(connector: connector)
    public private(set) lazy var code = SearchCode(connector: connector)
    public private(set) lazy var issues = SearchIssues(connector: connector)
    public private(set) lazy var users = SearchUsers(connector: connector)
    public private(set) lazy var topics = SearchTopics(connector: connector)
    public private(set) lazy var labels = SearchLabels(connector: connector)

    init(connector: GitHubConnector) {
        self.connector = connector
    }
}
