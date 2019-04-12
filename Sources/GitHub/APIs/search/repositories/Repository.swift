import struct Foundation.URL
import URITemplate

private var repositoryURLsCache = [Repository: RepositoryURLs]()
public struct Repository: GitHubResponseElement, Hashable {
    public let id: Int
    public let nodeID: String
    public let name: String
    public let fullName: String
    public let `private`: Bool
    public let owner: User
    public let description: String
    public let fork: Bool
    public var urls: RepositoryURLs {
        if let urls = repositoryURLsCache[self] {
            return urls
        }

        let urls = RepositoryURLs(repository: _api, html: _html, forks: _forks, keys: _keys,
                                  collaborators: _collaborators, teams: _teams, hooks: _hooks,
                                  issueEvents: _issueEvents, events: _events, assignees: _assignees,
                                  branches: _branches, tags: _tags, blobs: _blobs, gitTags: _gitTags, gitRefs: _gitRefs,
                                  trees: _trees, statuses: _statuses, languages: _languages, stargazers: _stargazers,
                                  contributors: _contributors, subscribers: _subscribers, subscription: _subscription,
                                  commits: _commits, gitCommits: _gitCommits, comments: _comments,
                                  issueComment: _issueComment, contents: _contents, compare: _compare, merges: _merges,
                                  archive: _archive, downloads: _downloads, issues: _issues, pulls: _pulls,
                                  milestones: _milestones, notifications: _notifications, labels: _labels,
                                  releases: _releases, deployments: _deployments, git: _git, ssh: _ssh, clone: _clone,
                                  svn: _svn, homepage: _homepage, mirror: _mirror)
        repositoryURLsCache[self] = urls

        return urls
    }

    public let _api, _html, _forks, _teams, _hooks, _events, _tags, _languages, _stargazers, _contributors,
        _subscribers, _subscription, _merges, _downloads, _deployments, _git, _ssh, _clone, _svn: URL
    public let _keys, _collaborators, _issueEvents, _assignees, _branches, _blobs, _gitTags, _gitRefs, _trees,
        _statuses, _commits, _gitCommits, _comments, _issueComment, _contents, _compare, _archive, _issues,
        _pulls, _milestones, _notifications, _labels, _releases: URITemplate
    public let _homepage: URITemplate?
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
        case id, nodeID = "node_id", name, fullName = "full_name", owner, `private`, description, fork, _api = "url",
            _html = "html_url", _forks = "forks_url", _keys = "keys_url", _collaborators = "collaborators_url",
            _teams = "teams_url", _hooks = "hooks_url", _issueEvents = "issue_events_url", _events = "events_url",
            _assignees = "assignees_url", _branches = "branches_url", _tags = "tags_url", _blobs = "blobs_url",
            _gitTags = "git_tags_url", _gitRefs = "git_refs_url", _trees = "trees_url", _statuses = "statuses_url",
            _languages = "languages_url", _stargazers = "stargazers_url", _contributors = "contributors_url",
            _subscribers = "subscribers_url", _subscription = "subscription_url", _commits = "commits_url",
            _gitCommits = "git_commits_url", _comments = "comments_url", _issueComment = "issue_comment_url",
            _contents = "contents_url", _compare = "compare_url", _merges = "merges_url", _archive = "archive_url",
            _downloads = "downloads_url", _issues = "issues_url", _pulls = "pulls_url", _milestones = "milestones_url",
            _notifications = "notifications_url", _labels = "labels_url", _releases = "releases_url",
            _deployments = "deployments_url", _git = "git_url", _ssh = "ssh_url", _clone = "clone_url", _svn = "svn_url",
            _homepage = "homepage", _mirror = "mirror_url", created = "created_at", updated = "updated_at",
            pushed = "pushed_at", size, stargazers = "stargazers_count", watchers, language, hasIssues = "has_issues",
            hasProjects = "has_projects", hasDownloads = "has_downloads", hasWiki = "has_wiki", hasPages = "has_pages",
            forks, archived, disabled, openIssues = "open_issues", license, defaultBranch = "default_branch", score
    }
}
