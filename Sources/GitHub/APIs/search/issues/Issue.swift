import struct Foundation.URL
import URITemplate

public struct Issue: GitHubResponseElement, Hashable {
    public var urls: IssueURLs {
        return IssueURLs(issue: _api, repository: _repository, labels: _labels, comments: _comments,
                         events: _events, html: _html)
    }

    public let _api, _repository, _comments, _events, _html: URL
    public let _labels: URITemplate
    public let id: Int
    public let nodeID: String
    public let number: Int
    public let title: String
    public let user: User
    public let labels: [Label]
    public let state: IssueState
    public let locked: Bool
    public let assignee: User?
    public let assignees: [User]
    public let milestone: Milestone?
    public let comments: Int
    public let created: GitHubDate
    public let updated: GitHubDate
    public let closed: GitHubDate?
    public let authorAssociation: Association
    public let pullRequest: PullRequest?
    public let body: String
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case _api = "url", _repository = "repository_url", _labels = "labels_url", _comments = "comments_url",
            _events = "events_url", _html = "html_url", id, nodeID = "node_id", number, title, user, labels, state,
            locked, assignee, assignees, milestone, comments, created = "created_at", updated = "updated_at",
            closed = "closed_at", authorAssociation = "author_association", pullRequest = "pull_request", body,
            score
    }
}
