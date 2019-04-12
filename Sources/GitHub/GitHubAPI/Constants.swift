import HTTP

public var numberOfThreads = System.coreCount
public let URLPathSeparator = "/"
public let githubPerPageDefault = 30
public let githubPerPageMax = 100
public var githubPerPage = githubPerPageDefault
public let githubBodyDecoder = JSONDecoder()
public let defaultAPIHeaders: HTTPHeaders = [
    "Accept": "application/vnd.github.v3+json",
    "User-Agent": "GitHubAPI-SPM-Library"
]
public let githubRateLimitHeader = HTTPHeaderName("X-RateLimit-Limit")
public let githubRateLimitRemainingHeader = HTTPHeaderName("X-RateLimit-Remaining")
public let githubRateLimitResetHeader = HTTPHeaderName("X-RateLimit-Reset")
