import struct Foundation.URL

public struct MilestoneURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(milestone: URL, html: URL, labels: URL) {
        apis = .init(milestone: milestone, labels: labels)
        webpage = html
    }

    public struct APIURLs: Hashable {
        public let milestone: URL
        public let labels: URL
    }
}
