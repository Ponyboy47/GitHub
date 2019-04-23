public enum DecodingError: Error {
    case invalidISO8601DateString(String)
    case invalidMediaType(String)
}

public enum GitHubAPIError: Error {
    case failedToStar
}
