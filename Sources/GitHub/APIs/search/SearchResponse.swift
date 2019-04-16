public struct GitHubSearchResponse<T: Decodable>: GitHubResponseRepresentable {
    public typealias Element = T

    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }

    public let total: Int
    public let incompleteResults: Bool
    public let items: [T]
}
