import HTTP

public final class SearchCode: GitHubAPI {
    public typealias Category = SearchCategory
    public typealias Options = URLQuery
    public typealias Element = Code

    public enum SortOptions: String {
        case indexed
        case bestMatch = "best-match"

        public static let `default`: SortOptions = .bestMatch
    }

    public static let endpoint = "code"
    public static let requiresAuth = true
    public static let method: HTTPMethod = .GET

    public let connector: GitHubConnector

    public init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(keywords: SearchKeyword = [],
                      qualifiers: CodeQualifier,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        let query = SearchQuery(keywords: keywords, qualifiers: qualifiers).rawValue
        return try self.query(query, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ search: SearchQuery<CodeQualifier>,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        return try query(search.rawValue, sort: sort, order: order, page: page, perPage: perPage)
    }

    public func query(_ string: String,
                      sort: SortOptions = .default,
                      order: SortOrdering = .default,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        var options = Options()
        options.add(option: "q", value: string)
        if order != .default {
            options.add(option: "order", value: order)

            // The sort parameter is ignored if the ordering is not specified
            if sort != .default {
                options.add(option: "sort", value: sort)
            }
        }

        return try call(options: options, page: page, perPage: perPage)
    }
}

private var codeURLsCache = [Code: CodeURLs]()
public struct Code: GitHubResponseElement, Hashable {
    public let name: String
    public let path: String
    public let sha: String
    public var urls: CodeURLs {
        if let urls = codeURLsCache[self] {
            return urls
        }

        let urls = CodeURLs(code: _api,
                            git: _git,
                            html: _html)
        codeURLsCache[self] = urls
        return urls
    }
    public let _api: URL
    public let _git: URL
    public let _html: URL
    public let repository: Repository
    public let score: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case path
        case sha
        case _api = "url"
        case _git = "git_url"
        case _html = "html_url"
        case repository
        case score
    }
}

public struct CodeURLs: GitHubURLContainer, Hashable {
    public let apis: APIURLs
    public let webpage: URL

    public init(code: URL, git: URL, html: URL) {
        apis = .init(code: code, git: git)
        webpage = html
    }

    public struct APIURLs: Hashable {
        public let code: URL
        public let git: URL
    }
}
