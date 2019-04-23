@testable import GitHub
import XCTest

final class GitHubGistsTests: XCTestCase {
    func testGetPublicGists() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.gists.public.query())
    }

    func testGetGistsByID() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.gists.id.query("f8213da3018fac99daf3d27d67f36903"))
    }

    static var allTests = [
        ("testGetPublicGists", testGetPublicGists),
        ("testGetGistsByID", testGetGistsByID)
    ]
}
