import class Foundation.JSONDecoder
import class NIO.EventLoopFuture
import enum NIO.System
import struct NIOHTTP1.HTTPHeaders
import class NIOHTTPClient.HTTPClient

typealias HTTPResponse = HTTPClient.Response
typealias HTTPRequest = HTTPClient.Request
typealias HTTPBody = HTTPClient.Body
typealias Future = EventLoopFuture

let numberOfThreads = System.coreCount
let URLPathSeparator = "/"
public let githubURL = "https://api.github.com"
public let githubPerPageDefault = 30
public let githubPerPageMax = 100
public var githubPerPage = githubPerPageDefault
let githubBodyDecoder = JSONDecoder()
let defaultAPIHeaders: HTTPHeaders = [
    "Accept": "application/vnd.github.v3+json",
    "User-Agent": "GitHubAPI-SPM-Library"
]
let githubRateLimitHeader = "X-RateLimit-Limit"
let githubRateLimitRemainingHeader = "X-RateLimit-Remaining"
let githubRateLimitResetHeader = "X-RateLimit-Reset"
