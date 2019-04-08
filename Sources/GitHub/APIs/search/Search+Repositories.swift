import HTTP

public final class SearchRepositories: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Element = Repository

    public enum SortOptions: String {
        case stars
        case forks
        case helpWantedIssues = "help-wanted-issues"
        case updated
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    public static let endpoint = "repositories"
    public static let requiresAuth = false
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(_ search: SearchQuery<RepositoryQualifier>,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        return try query(search.rawValue, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ string: String,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        var options = Options()
        options.add(option: "q", value: string)
        if order != .default {
            options.add(option: "order", value: order)

            // The sort parameter is ignored if the ordering is not specified
            if sort != .default {
                options.add(option: "sort", value: sort)
            }
        }

        return try call(options: options, page: page, perPage: perPage)
    }
}

public struct Repository: GitHubResponseElement {
    public let id: Int
    public let nodeID: String
    public let name: String
    public let fullName: String
    public let owner: User
    public let `private`: Bool
    public let description: String
    public let fork: Bool
    public let url: URL
    public lazy var urls: RepositoryURLs = {
        return RepositoryURLs(html: _html,
                              forks: _forks,
                              keys: _keys,
                              collaborators: _collaborators,
                              teams: _teams,
                              hooks: _hooks,
                              issueEvents: _issueEvents,
                              events: _events,
                              assignees: _assignees,
                              branches: _branches,
                              tags: _tags,
                              blobs: _blobs,
                              gitTags: _gitTags,
                              gitRefs: _gitRefs,
                              trees: _trees,
                              statuses: _statuses,
                              languages: _languages,
                              stargazers: _stargazers,
                              contributors: _contributors,
                              subscribers: _subscribers,
                              subscription: _subscription,
                              commits: _commits,
                              gitCommits: _gitCommits,
                              comments: _comments,
                              issueComment: _issueComment,
                              contents: _contents,
                              compare: _compare,
                              merges: _merges,
                              archive: _archive,
                              downloads: _downloads,
                              issues: _issues,
                              pulls: _pulls,
                              milestones: _milestones,
                              notifications: _notifications,
                              labels: _labels,
                              releases: _releases,
                              deployments: _deployments)
    }()
    public let _html: URL
    public let _forks: URL
    public let _keys: URL
    public let _collaborators: URL
    public let _teams: URL
    public let _hooks: URL
    public let _issueEvents: URL
    public let _events: URL
    public let _assignees: URL
    public let _branches: URL
    public let _tags: URL
    public let _blobs: URL
    public let _gitTags: URL
    public let _gitRefs: URL
    public let _trees: URL
    public let _statuses: URL
    public let _languages: URL
    public let _stargazers: URL
    public let _contributors: URL
    public let _subscribers: URL
    public let _subscription: URL
    public let _commits: URL
    public let _gitCommits: URL
    public let _comments: URL
    public let _issueComment: URL
    public let _contents: URL
    public let _compare: URL
    public let _merges: URL
    public let _archive: URL
    public let _downloads: URL
    public let _issues: URL
    public let _pulls: URL
    public let _milestones: URL
    public let _notifications: URL
    public let _labels: URL
    public let _releases: URL
    public let _deployments: URL
    public let created: Date
    public let updated: Date
    public let pushed: Date
    public let homepage: URL?
    public let size: ByteSize
    public let stargazers: Int
    public let watchers: Int
    public let language: String
    public let forks: Int
    public let openIssues: Int
    public let masterBranch: String
    public let defaultBranch: String
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case owner
        case `private`
        case description
        case fork
        case url
        case _html = "html_url"
        case _forks = "forks_url"
        case _keys = "keys_url"
        case _collaborators = "collaborators_url"
        case _teams = "teams_url"
        case _hooks = "hooks_url"
        case _issueEvents = "issue_events_url"
        case _events = "events_url"
        case _assignees = "assignees_url"
        case _branches = "branches_url"
        case _tags = "tags_url"
        case _blobs = "blobs_url"
        case _gitTags = "git_tags_url"
        case _gitRefs = "git_refs_url"
        case _trees = "trees_url"
        case _statuses = "statuses_url"
        case _languages = "languages_url"
        case _stargazers = "stargazers_url"
        case _contributors = "contributors_url"
        case _subscribers = "subscribers_url"
        case _subscription = "subscription_url"
        case _commits = "commits_url"
        case _gitCommits = "git_commits_url"
        case _comments = "comments_url"
        case _issueComment = "issue_comment_url"
        case _contents = "contents_url"
        case _compare = "compare_url"
        case _merges = "merges_url"
        case _archive = "archive_url"
        case _downloads = "downloads_url"
        case _issues = "issues_url"
        case _pulls = "pulls_url"
        case _milestones = "milestones_url"
        case _notifications = "notifications_url"
        case _labels = "labels_url"
        case _releases = "releases_url"
        case _deployments = "deployments_url"
        case created = "created_at"
        case updated = "updated_at"
        case pushed = "pushed_at"
        case homepage
        case size
        case stargazers = "stargazers_count"
        case watchers = "watchers_count"
        case language
        case forks = "forks_count"
        case openIssues = "open_issues_count"
        case masterBranch = "master_branch"
        case defaultBranch = "default_branch"
        case score
    }
}

public struct RepositoryURLs {
    public let html: URL
    public let forks: URL
    public let keys: URL
    public let collaborators: URL
    public let teams: URL
    public let hooks: URL
    public let issueEvents: URL
    public let events: URL
    public let assignees: URL
    public let branches: URL
    public let tags: URL
    public let blobs: URL
    public let gitTags: URL
    public let gitRefs: URL
    public let trees: URL
    public let statuses: URL
    public let languages: URL
    public let stargazers: URL
    public let contributors: URL
    public let subscribers: URL
    public let subscription: URL
    public let commits: URL
    public let gitCommits: URL
    public let comments: URL
    public let issueComment: URL
    public let contents: URL
    public let compare: URL
    public let merges: URL
    public let archive: URL
    public let downloads: URL
    public let issues: URL
    public let pulls: URL
    public let milestones: URL
    public let notifications: URL
    public let labels: URL
    public let releases: URL
    public let deployments: URL
}
