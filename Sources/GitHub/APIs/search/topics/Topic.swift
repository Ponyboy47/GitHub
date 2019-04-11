public struct Topic: GitHubResponseElement {
    public let name: String
    public let displayName: String
    public let shortDescription: String
    public let description: String
    public let createdBy: String
    public let released: String
    public let created: GitHubDate
    public let updated: GitHubDate
    public let featured: Bool
    public let curated: Bool
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case displayName = "display_name"
        case shortDescription = "short_description"
        case description
        case createdBy = "created_by"
        case released
        case created = "created_at"
        case updated = "updated_at"
        case featured
        case curated
        case score
    }
}
