public struct GitHubSearchResponse<T: Decodable>: GitHubResponseRepresentable {
    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }

    public let total: Int
    public let incompleteResults: Bool
    public let items: [T]
}
