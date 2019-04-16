import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GitHubSearchTests.allTests),
        testCase(GitHubGistsTests.allTests)
    ]
}
#endif
