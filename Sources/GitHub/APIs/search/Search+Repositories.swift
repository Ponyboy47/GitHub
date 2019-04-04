import HTTP

public final class SearchRepositories: GitHubAPI {
    public typealias Category = SearchCategory

    public struct Options: HTTPRequestRepresentable {
        public static let isBody = false

        public func stringRepresentation() -> String {
            return ""
        }
    }

    public static let endpoint = "repositories"
    public static let requiresAuth = false
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }
}
