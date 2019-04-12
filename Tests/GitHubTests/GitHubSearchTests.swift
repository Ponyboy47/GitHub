import XCTest
@testable import GitHub

final class GitHubSearchTests: XCTestCase {
    func testSearchRepositories() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.search.repositories.query(qualifiers: [.topic("ruby"), .topic("rails")]))
    }

    func testSearchCommits() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.search.commits.query(keywords: "css", qualifiers: .repo("octocat/Spoon-Knife")))
    }

    func testSearchCode() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.search.code.query(keywords: "addClass", qualifiers: [.in(.file), .language("js"), .repo("jquery", user: "jquery")]))
    }

    func testSearchIssues() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.search.issues.query(keywords: "windows", qualifiers: [.label("bug"), .language("python"), .state(.open)], sort: .created, order: .asc))
    }

    func testSearchUsers() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.search.users.query(keywords: "tom", qualifiers: [.repos(greaterThan: 42), .followers(greaterThanOrEqualTo: 1000)]))
    }

    func testSearchTopics() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.search.topics.query(keywords: "ruby", qualifiers: [.is(.featured)]))
    }

    func testSearchLabels() {
        let gh = GitHub()
        XCTAssertNoThrow(try gh.search.labels.query(["bug", "defect", "enhancement"], repositoryID: 64778136))
    }

    static var allTests = [
        ("testSearchRepositories", testSearchRepositories),
        ("testSearchCommits", testSearchCommits),
        ("testSearchCode", testSearchCode),
        ("testSearchIssues", testSearchIssues),
        ("testSearchUsers", testSearchUsers),
        ("testSearchTopics", testSearchTopics),
        ("testSearchLabels", testSearchLabels),
    ]
}
