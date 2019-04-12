import struct Foundation.URL

private var milestoneURLsCache = [Milestone: MilestoneURLs]()
public struct Milestone: Decodable, Hashable {
    public let id: Int
    public let nodeID: String
    public let number: Int
    public let title: String
    public let description: String
    public var urls: MilestoneURLs {
        if let urls = milestoneURLsCache[self] {
            return urls
        }

        let urls = MilestoneURLs(milestone: _api, html: _html, labels: _labels)
        milestoneURLsCache[self] = urls
        return urls
    }

    public let _api, _html, _labels: URL
    public let creator: User
    public let openIssues: Int
    public let closedIssues: Int
    public let state: IssueState
    public let created: GitHubDate
    public let updated: GitHubDate
    public let due: GitHubDate
    public let closed: GitHubDate?

    enum CodingKeys: String, CodingKey {
        case id, nodeID = "node_id", number, title, description, _api = "url", _html = "html_url",
            _labels = "labels_url", creator, openIssues = "open_issues", closedIssues = "closed_issues",
            state, created = "created_at", updated = "updated_at", due = "due_on", closed = "closed_at"
    }
}
