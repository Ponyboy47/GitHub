import struct Foundation.URL
import URITemplate

public struct RepositoryURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL
    public let others: OtherURLs

    public init(repository: URL, html: URL, forks: URL, keys: URITemplate, collaborators: URITemplate, teams: URL,
                hooks: URL, issueEvents: URITemplate, events: URL, assignees: URITemplate, branches: URITemplate,
                tags: URL, blobs: URITemplate, gitTags: URITemplate, gitRefs: URITemplate, trees: URITemplate,
                statuses: URITemplate, languages: URL, stargazers: URL, contributors: URL, subscribers: URL,
                subscription: URL, commits: URITemplate, gitCommits: URITemplate, comments: URITemplate,
                issueComment: URITemplate, contents: URITemplate, compare: URITemplate, merges: URL,
                archive: URITemplate, downloads: URL, issues: URITemplate, pulls: URITemplate, milestones: URITemplate,
                notifications: URITemplate, labels: URITemplate, releases: URITemplate, deployments: URL, git: URL,
                ssh: URL, clone: URL, svn: URL, homepage: URITemplate?, mirror: URL?) {
        apis = .init(repository: repository, forks: forks, teams: teams, hooks: hooks, events: events, tags: tags,
                     languages: languages, stargazers: stargazers, contributors: contributors, subscribers:
                     subscribers, subscription: subscription, merges: merges, downloads: downloads, deployments:
                     deployments, _keys: keys, _collaborators: collaborators, _issueEvents: issueEvents, _assignees:
                     assignees, _branches: branches, _blobs: blobs, _gitTags: gitTags, _gitRefs: gitRefs, _trees:
                     trees, _statuses: statuses, _commits: commits, _gitCommits: gitCommits, _comments: comments,
                     _issueComment: issueComment, _contents: contents, _compare: compare, _archive: archive, _issues:
                     issues, _pulls: pulls, _milestones: milestones, _notifications: notifications, _labels: labels,
                     _releases: releases)
        webpage = html
        others = .init(git: git, ssh: ssh, clone: clone, svn: svn, homepage: homepage, mirror: mirror)
    }

    public struct APIURLs: Hashable {
        public let repository, forks, teams, hooks, events, tags, languages, stargazers, contributors, subscribers,
            subscription, merges, downloads, deployments: URL
        public let _keys, _collaborators, _issueEvents, _assignees, _branches, _blobs, _gitTags, _gitRefs, _trees,
            _statuses, _commits, _gitCommits, _comments, _issueComment, _contents, _compare, _archive, _issues,
            _pulls, _milestones, _notifications, _labels, _releases: URITemplate
    }

    public struct OtherURLs: Hashable {
        public let git: URL
        public let ssh: URL
        public let clone: URL
        public let svn: URL
        public let homepage: URITemplate?
        public let mirror: URL?
    }
}
