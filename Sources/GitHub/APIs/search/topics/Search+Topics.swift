import struct NIOHTTP1.HTTPHeaders
import URITemplate

public final class SearchTopics: GitHubAPI {
    public typealias Response = GitHubSearchResponse<Topic>

    public typealias SortOptions = Void

    static let requiredHeaders: HTTPHeaders = {
        var headers = defaultAPIHeaders
        headers.replaceOrAdd(name: "Accept", value: "application/vnd.github.mercy-preview+json")
        return headers
    }()

    static let endpoint: URITemplate = "/search/topics?q={+query}{&page,per_page}"

    let connector: GitHubConnector

    init(connector: GitHubConnector) {
        self.connector = connector
    }

    public func query(keywords: SearchKeyword = [],
                      qualifiers: TopicQualifier,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        let query = SearchQuery(keywords: keywords, qualifiers: qualifiers).rawValue
        return try self.query(query, page: page, perPage: perPage)
    }

    public func query(_ search: SearchQuery<TopicQualifier>,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        return try query(search.rawValue, page: page, perPage: perPage)
    }

    public func query(_ string: String,
                      page: Int = 1,
                      perPage: Int = githubPerPage) throws -> Response {
        var options = [String: RestfulParameter]()
        options["query"] = string
        options["page"] = page
        options["per_page"] = perPage

        return try get(parameters: options)
    }
}
