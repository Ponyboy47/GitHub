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

    public func query(keywords: SearchKeyword = [],
                      qualifiers: RepositoryQualifier,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        let query = SearchQuery(keywords: keywords, qualifiers: qualifiers).rawValue
        return try self.query(query, sort: sort, order: order, page: page, perPage: perPage)
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
    public let `private`: Bool
    public let owner: User
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
                              deployments: _deployments,
                              git: _git,
                              ssh: _ssh,
                              clone: _clone,
                              svn: _svn,
                              homepage: _homepage,
                              mirror: _mirror)
    }()
    public let _html: URL
    public let _forks: URL
    public let _keys: String
    public let _collaborators: String
    public let _teams: URL
    public let _hooks: URL
    public let _issueEvents: String
    public let _events: URL
    public let _assignees: String
    public let _branches: String
    public let _tags: URL
    public let _blobs: String
    public let _gitTags: String
    public let _gitRefs: String
    public let _trees: String
    public let _statuses: String
    public let _languages: URL
    public let _stargazers: URL
    public let _contributors: URL
    public let _subscribers: URL
    public let _subscription: URL
    public let _commits: String
    public let _gitCommits: String
    public let _comments: String
    public let _issueComment: String
    public let _contents: String
    public let _compare: String
    public let _merges: URL
    public let _archive: String
    public let _downloads: URL
    public let _issues: String
    public let _pulls: String
    public let _milestones: String
    public let _notifications: String
    public let _labels: String
    public let _releases: String
    public let _deployments: URL
    public let _git: URL
    public let _ssh: URL
    public let _clone: URL
    public let _svn: URL
    public let _homepage: String?
    public let _mirror: URL?
    public let created: GitHubDate
    public let updated: GitHubDate
    public let pushed: GitHubDate
    public let size: ByteSize
    public let stargazers: Int
    public let watchers: Int
    public let language: String
    public let hasIssues: Bool
    public let hasProjects: Bool
    public let hasDownloads: Bool
    public let hasWiki: Bool
    public let hasPages: Bool
    public let forks: Int
    public let archived: Bool
    public let disabled: Bool
    public let openIssues: Int
    public let license: License?
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
        case _git = "git_url"
        case _ssh = "ssh_url"
        case _clone = "clone_url"
        case _svn = "svn_url"
        case _homepage = "homepage"
        case _mirror = "mirror_url"
        case created = "created_at"
        case updated = "updated_at"
        case pushed = "pushed_at"
        case size
        case stargazers = "stargazers_count"
        case watchers
        case language
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasDownloads = "has_downloads"
        case hasWiki = "has_wiki"
        case hasPages = "has_pages"
        case forks
        case archived
        case disabled
        case openIssues = "open_issues"
        case license
        case defaultBranch = "default_branch"
        case score
    }
}

public struct RepositoryURLs {
    public let html: URL
    public let forks: URL
    public let keys: String
    public let collaborators: String
    public let teams: URL
    public let hooks: URL
    public let issueEvents: String
    public let events: URL
    public let assignees: String
    public let branches: String
    public let tags: URL
    public let blobs: String
    public let gitTags: String
    public let gitRefs: String
    public let trees: String
    public let statuses: String
    public let languages: URL
    public let stargazers: URL
    public let contributors: URL
    public let subscribers: URL
    public let subscription: URL
    public let commits: String
    public let gitCommits: String
    public let comments: String
    public let issueComment: String
    public let contents: String
    public let compare: String
    public let merges: URL
    public let archive: String
    public let downloads: URL
    public let issues: String
    public let pulls: String
    public let milestones: String
    public let notifications: String
    public let labels: String
    public let releases: String
    public let deployments: URL
    public let git: URL
    public let ssh: URL
    public let clone: URL
    public let svn: URL
    public let homepage: String?
    public let mirror: URL?
}

public struct License: Decodable {
    public let key: SupportedLicense
    public let name: String
    public let spdxID: String
    public let url: URL?
    public let nodeID: String

    enum CodingKeys: String, CodingKey {
        case key
        case name
        case spdxID = "spdx_id"
        case url
        case nodeID = "node_id"
    }
}
