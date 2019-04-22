@testable import GitHub
import XCTest

final class GitHubGistsTests: XCTestCase {
    func testGetUserGists() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.gists.user.query("Ponyboy47"))
    }

    func testGetPublicGists() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.gists.public.query())
    }

    static var allTests = [
        ("testGetUserGists", testGetUserGists),
        ("testGetPublicGists", testGetPublicGists)
    ]
}
