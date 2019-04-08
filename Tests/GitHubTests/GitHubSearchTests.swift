import XCTest
@testable import GitHub

final class GitHubSearchTests: XCTestCase {
    func testSearchRepositories() {
        let gh = GitHub()
        
        XCTAssertNoThrow(try gh.search.repositories.query(qualifiers: .language("swift")))
    }

    static var allTests = [
        ("testSearchRepositories", testSearchRepositories),
    ]
}
