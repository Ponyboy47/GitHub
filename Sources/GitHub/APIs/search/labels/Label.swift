import struct Foundation.URL

public struct Label: GitHubResponseElement, Hashable {
    public let id: Int
    public let nodeID: String
    public let url: URL
    public let name: String
    public let color: String
    public let `default`: Bool
    public let description: String?
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case id, nodeID = "node_id", url, name, color, `default`, description, score
    }
}
