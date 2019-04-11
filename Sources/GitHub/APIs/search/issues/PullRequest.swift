import struct Foundation.URL

public struct PullRequest: Decodable, Hashable {
    public let html: URL
    public let diff: URL
    public let patch: URL

    enum CodingKeys: String, CodingKey {
        case html = "html_url"
        case diff = "diff_url"
        case patch = "patch_url"
    }
}
