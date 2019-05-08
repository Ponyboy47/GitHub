import struct Foundation.URL

public protocol GitHubResponseRepresentable: Decodable {}

public protocol GitHubResponseElement: Decodable {
    associatedtype URLsContainer: GitHubURLContainer = Empty
    var urls: URLsContainer { get }
}

public extension GitHubResponseElement where URLsContainer == Empty {
    var urls: Empty { return Empty() }
}

public protocol GitHubURLContainer {
    associatedtype APIURLs
    associatedtype WebPageURL = URL
    associatedtype OtherURLs = Void

    var apis: APIURLs { get }
    var webpage: WebPageURL { get }
    var others: OtherURLs { get }
}

public extension GitHubURLContainer where OtherURLs == Void {
    var others: Void { return () }
}

public struct Empty: GitHubURLContainer {
    public let apis: Void = ()
    public let webpage: Void = ()

    public init() {}
}

extension Array: GitHubResponseRepresentable where Element: Decodable {}
