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

    func testGetGistsByID() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.gists.id.query("f8213da3018fac99daf3d27d67f36903"))
    }

    static var allTests = [
        ("testGetUserGists", testGetUserGists),
        ("testGetPublicGists", testGetPublicGists),
        ("testGetGistsByID", testGetGistsByID)
    ]
}
