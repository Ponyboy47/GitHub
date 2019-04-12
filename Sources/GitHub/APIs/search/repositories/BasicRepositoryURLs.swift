import struct Foundation.URL
import URITemplate

public struct BasicRepositoryURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(repository: URL, html: URL, forks: URL, keys: URITemplate, collaborators: URITemplate, teams: URL,
                hooks: URL, issueEvents: URITemplate, events: URL, assignees: URITemplate, branches: URITemplate,
                tags: URL, blobs: URITemplate, gitTags: URITemplate, gitRefs: URITemplate, trees: URITemplate,
                statuses: URITemplate, languages: URL, stargazers: URL, contributors: URL, subscribers: URL,
                subscription: URL, commits: URITemplate, gitCommits: URITemplate, comments: URITemplate,
                issueComment: URITemplate, contents: URITemplate, compare: URITemplate, merges: URL,
                archive: URITemplate, downloads: URL, issues: URITemplate, pulls: URITemplate, milestones: URITemplate,
                notifications: URITemplate, labels: URITemplate, releases: URITemplate, deployments: URL) {
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
    }

    public struct APIURLs: Hashable {
        public let repository, forks, teams, hooks, events, tags, languages, stargazers, contributors, subscribers,
            subscription, merges, downloads, deployments: URL
        public let _keys, _collaborators, _issueEvents, _assignees, _branches, _blobs, _gitTags, _gitRefs, _trees,
            _statuses, _commits, _gitCommits, _comments, _issueComment, _contents, _compare, _archive, _issues,
            _pulls, _milestones, _notifications, _labels, _releases: URITemplate

        public init(repository: URL, forks: URL, keys: URITemplate, collaborators: URITemplate, teams: URL, hooks: URL,
                    issueEvents: URITemplate, events: URL, assignees: URITemplate, branches: URITemplate, tags: URL,
                    blobs: URITemplate, gitTags: URITemplate, gitRefs: URITemplate, trees: URITemplate,
                    statuses: URITemplate, languages: URL, stargazers: URL, contributors: URL, subscribers: URL,
                    subscription: URL, commits: URITemplate, gitCommits: URITemplate, comments: URITemplate,
                    issueComment: URITemplate, contents: URITemplate, compare: URITemplate, merges: URL,
                    archive: URITemplate, downloads: URL, issues: URITemplate, pulls: URITemplate,
                    milestones: URITemplate, notifications: URITemplate, labels: URITemplate, releases: URITemplate,
                    deployments: URL) {
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
}
