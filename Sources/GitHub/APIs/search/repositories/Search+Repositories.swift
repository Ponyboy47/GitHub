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
               _pulls, _milestones, _notifications, _labels, _releases: String
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

public struct RepositoryURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL
    public let others: OtherURLs

    public init(repository: URL, html: URL, forks: URL, keys: String, collaborators: String, teams: URL, hooks: URL,
                issueEvents: String, events: URL, assignees: String, branches: String, tags: URL, blobs: String,
                gitTags: String, gitRefs: String, trees: String, statuses: String, languages: URL, stargazers: URL,
                contributors: URL, subscribers: URL, subscription: URL, commits: String, gitCommits: String,
                comments: String, issueComment: String, contents: String, compare: String, merges: URL,
                archive: String, downloads: URL, issues: String, pulls: String, milestones: String,
                notifications: String, labels: String, releases: String, deployments: URL, git: URL, ssh: URL,
                clone: URL, svn: URL, homepage: String?, mirror: URL?) {
        apis = .init(repository: repository, forks: forks, keys: keys, collaborators: collaborators, teams: teams,
                     hooks: hooks, issueEvents: issueEvents, events: events, assignees: assignees, branches: branches,
                     tags: tags, blobs: blobs, gitTags: gitTags, gitRefs: gitRefs, trees: trees, statuses: statuses,
                     languages: languages, stargazers: stargazers, contributors: contributors,
                     subscribers: subscribers, subscription: subscription, commits: commits, gitCommits: gitCommits,
                     comments: comments, issueComment: issueComment, contents: contents, compare: compare,
                     merges: merges, archive: archive, downloads: downloads, issues: issues, pulls: pulls,
                     milestones: milestones, notifications: notifications, labels: labels, releases: releases,
                     deployments: deployments)
        webpage = html
        others = .init(git: git, ssh: ssh, clone: clone, svn: svn, homepage: homepage, mirror: mirror)
    }

    public struct APIURLs: Hashable {
        public let repository, forks, teams, hooks, events, tags, languages, stargazers, contributors, subscribers,
                   subscription, merges, downloads, deployments: URL
        public let _keys, _collaborators, _issueEvents, _assignees, _branches, _blobs, _gitTags, _gitRefs, _trees,
                   _statuses, _commits, _gitCommits, _comments, _issueComment, _contents, _compare, _archive, _issues,
                   _pulls, _milestones, _notifications, _labels, _releases: String

        public init(repository: URL, forks: URL, keys: String, collaborators: String, teams: URL, hooks: URL,
                    issueEvents: String, events: URL, assignees: String, branches: String, tags: URL, blobs: String,
                    gitTags: String, gitRefs: String, trees: String, statuses: String, languages: URL, stargazers: URL,
                    contributors: URL, subscribers: URL, subscription: URL, commits: String, gitCommits: String,
                    comments: String, issueComment: String, contents: String, compare: String, merges: URL,
                    archive: String, downloads: URL, issues: String, pulls: String, milestones: String,
                    notifications: String, labels: String, releases: String, deployments: URL) {
            self.repository = repository
            self.forks = forks
            _keys = keys
            _collaborators = collaborators
            self.teams = teams
            self.hooks = hooks
            _issueEvents = issueEvents
            self.events = events
            _assignees = assignees
            _branches = branches
            self.tags = tags
            _blobs = blobs
            _gitTags = gitTags
            _gitRefs = gitRefs
            _trees = trees
            _statuses = statuses
            self.languages = languages
            self.stargazers = stargazers
            self.contributors = contributors
            self.subscribers = subscribers
            self.subscription = subscription
            _commits = commits
            _gitCommits = gitCommits
            _comments = comments
            _issueComment = issueComment
            _contents = contents
            _compare = compare
            self.merges = merges
            _archive = archive
            self.downloads = downloads
            _issues = issues
            _pulls = pulls
            _milestones = milestones
            _notifications = notifications
            _labels = labels
            _releases = releases
            self.deployments = deployments
        }
    }

    public struct OtherURLs: Hashable {
        public let git: URL
        public let ssh: URL
        public let clone: URL
        public let svn: URL
        public let homepage: String?
        public let mirror: URL?
    }
}

public struct License: Decodable, Hashable {
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
