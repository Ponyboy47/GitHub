import struct Foundation.Date

public struct IssueQualifier: SearchQualifier {
    public var _qualifiers = Set<String>()

    public init() {}
}

// MARK: Support qualifying by issue type

public extension IssueQualifier {
    enum IssueType: String {
        case issue
        case pr
        public static let pullRequest = IssueType.pr
    }

    static func `is`(_ type: IssueType) -> IssueQualifier {
        return .init(rawValue: "is:\(type.rawValue)")
    }

    static func type(_ type: IssueType) -> IssueQualifier {
        return .init(rawValue: "type:\(type.rawValue)")
    }
}

// MARK: Support 'in:qualifier'

extension IssueQualifier: InQualifiable {
    public enum InQualifier: String {
        case title
        case body
        case comments
    }
}

// MARK: Support qualifiers for user, organization, and repository

extension IssueQualifier: UserQualifiable {}
extension IssueQualifier: OrganizationQualifiable {}
extension IssueQualifier: RepositoryQualifiable {}

// MARK: Support qualifying by issue state

public enum IssueState: String, Decodable, Hashable {
    case open
    case closed
}

public extension IssueQualifier {
    static func `is`(_ state: IssueState) -> IssueQualifier {
        return .init(rawValue: "is:\(state.rawValue)")
    }

    static func state(_ state: IssueState) -> IssueQualifier {
        return .init(rawValue: "state:\(state.rawValue)")
    }
}

// MARK: Support qualifier for public or private issues

extension IssueQualifier: PublicPrivateQualifiable {}

// MARK: Support qualifier for issue author

public extension IssueQualifier {
    static func author(_ username: String) -> IssueQualifier {
        return .init(rawValue: "author:\(username)")
    }

    static func author(app username: String) -> IssueQualifier {
        return .init(rawValue: "author:app/\(username)")
    }

    static func author(integration username: String) -> IssueQualifier {
        return .author(app: username)
    }
}

// MARK: Support qualifier based on issue assignee

public extension IssueQualifier {
    static func assignee(_ username: String) -> IssueQualifier {
        return .init(rawValue: "assignee:\(username)")
    }
}

// MARK: Support qualifier based on issue mentions

public extension IssueQualifier {
    static func mentions(_ username: String) -> IssueQualifier {
        return .init(rawValue: "mentions:\(username)")
    }

    static func mentions(team org: String, user username: String) -> IssueQualifier {
        return .init(rawValue: "team:\(org)/\(username)")
    }
}

// MARK: Support qualifier based on issue commenter

public extension IssueQualifier {
    static func commenter(_ username: String) -> IssueQualifier {
        return .init(rawValue: "commenter:\(username)")
    }
}

// MARK: Support qualifier based on issue involves

public extension IssueQualifier {
    static func involves(_ username: String) -> IssueQualifier {
        return .init(rawValue: "involves:\(username)")
    }
}

// MARK: Support the label qualifier

public extension IssueQualifier {
    static func label(_ label: String) -> IssueQualifier {
        return .init(rawValue: "label:\(label)")
    }
}

// MARK: Support the miletone qualifier

public extension IssueQualifier {
    static func milestone(_ milestone: String) -> IssueQualifier {
        return .init(rawValue: "milestone:\(milestone)")
    }
}

// MARK: Support qualifying by project board

public extension IssueQualifier {
    static func project(_ project: String, board: Int) -> IssueQualifier {
        return .init(rawValue: "project:\(project)/\(board)")
    }

    static func project(_ project: String, board: Int, repo: String) -> IssueQualifier {
        return .init(rawValue: "project:\(repo)/\(project)/\(board)")
    }
}

// MARK: Support qualifying based on commit status

public extension IssueQualifier {
    enum CommitStatus: String {
        case pending
        case success
        case failure
    }

    static func status(_ status: CommitStatus) -> IssueQualifier {
        return .init(rawValue: "status:\(status.rawValue)")
    }
}

// MARK: Support qualifying based on commit SHA hash

public extension IssueQualifier {
    static func sha(_ hash: String) -> IssueQualifier {
        return .init(rawValue: hash)
    }

    static func hash(_ hash: String) -> IssueQualifier {
        return .sha(hash)
    }
}

// MARK: Support qualifying from a branch name

public extension IssueQualifier {
    static func head(_ branch: String) -> IssueQualifier {
        return .init(rawValue: "head:\(branch)")
    }

    static func base(_ branch: String) -> IssueQualifier {
        return .init(rawValue: "base:\(branch)")
    }
}

// MARK: Support qualifying based on programming language

extension IssueQualifier: LanguageQualifiable {}

// MARK: Support comments qualifiers

public extension IssueQualifier {
    static func comments(equals comments: Int) -> IssueQualifier {
        return .init(rawValue: "comments:\(comments)")
    }

    static func comments(greaterThan comments: Int) -> IssueQualifier {
        return .init(rawValue: "comments:>\(comments)")
    }

    static func comments(greaterThanOrEqualTo comments: Int) -> IssueQualifier {
        return .init(rawValue: "comments:>=\(comments)")
    }

    static func comments(lessThan comments: Int) -> IssueQualifier {
        return .init(rawValue: "comments:<\(comments)")
    }

    static func comments(lessThanOrEqualTo comments: Int) -> IssueQualifier {
        return .init(rawValue: "comments:<=\(comments)")
    }

    static func comments(between lowerBound: Int, and upperBound: Int) -> IssueQualifier {
        return .init(rawValue: "comments:\(lowerBound)..\(upperBound)")
    }

    static func comments(in range: ClosedRange<Int>) -> IssueQualifier {
        return .comments(between: range.lowerBound, and: range.upperBound)
    }

    static func comments(in range: PartialRangeThrough<Int>) -> IssueQualifier {
        return .comments(lessThanOrEqualTo: range.upperBound)
    }

    static func comments(in range: PartialRangeFrom<Int>) -> IssueQualifier {
        return .comments(greaterThanOrEqualTo: range.lowerBound)
    }
}

// MARK: Support qualifying for draft pull requests

public extension IssueQualifier {
    static var isDraft: IssueQualifier {
        return .init(rawValue: "is:draft")
    }
}

// MARK: Support pull request review status qualifiers

public extension IssueQualifier {
    enum PRReviewStatus: String {
        case none
        case required
        case approved
        case changesRequested = "changed_requested"
    }

    static func review(_ review: PRReviewStatus) -> IssueQualifier {
        return .init(rawValue: "review:\(review.rawValue)")
    }

    static func reviewed(by username: String) -> IssueQualifier {
        return .init(rawValue: "reviewed-by:\(username)")
    }

    static func review(requestedBy username: String) -> IssueQualifier {
        return .init(rawValue: "review-requested:\(username)")
    }

    static func review(requestedByTeam team: String) -> IssueQualifier {
        return .init(rawValue: "team-review-requested:\(team)")
    }
}

// MARK: Support created, updated, closed, and merged qualifiers

extension IssueQualifier: CreatedQualifiable {}
public extension IssueQualifier {
    static func updated(on date: Date) -> IssueQualifier {
        return .init(rawValue: "updated:\(date.iso8601)")
    }

    static func updated(after date: Date) -> IssueQualifier {
        return .init(rawValue: "updated:>\(date.iso8601)")
    }

    static func updated(afterOrOn date: Date) -> IssueQualifier {
        return .init(rawValue: "updated:>=\(date.iso8601)")
    }

    static func updated(before date: Date) -> IssueQualifier {
        return .init(rawValue: "updated:<\(date.iso8601)")
    }

    static func updated(beforeOrOn date: Date) -> IssueQualifier {
        return .init(rawValue: "updated:<=\(date.iso8601)")
    }

    static func updated(between lowerBound: Date, and upperBound: Date) -> IssueQualifier {
        return .init(rawValue: "updated:\(lowerBound.iso8601)..\(upperBound.iso8601)")
    }

    static func updated(in range: ClosedRange<Date>) -> IssueQualifier {
        return .updated(between: range.lowerBound, and: range.upperBound)
    }

    static func updated(in range: PartialRangeThrough<Date>) -> IssueQualifier {
        return .updated(beforeOrOn: range.upperBound)
    }

    static func updated(in range: PartialRangeFrom<Date>) -> IssueQualifier {
        return .updated(afterOrOn: range.lowerBound)
    }

    static func closed(on date: Date) -> IssueQualifier {
        return .init(rawValue: "closed:\(date.iso8601)")
    }

    static func closed(after date: Date) -> IssueQualifier {
        return .init(rawValue: "closed:>\(date.iso8601)")
    }

    static func closed(afterOrOn date: Date) -> IssueQualifier {
        return .init(rawValue: "closed:>=\(date.iso8601)")
    }

    static func closed(before date: Date) -> IssueQualifier {
        return .init(rawValue: "closed:<\(date.iso8601)")
    }

    static func closed(beforeOrOn date: Date) -> IssueQualifier {
        return .init(rawValue: "closed:<=\(date.iso8601)")
    }

    static func closed(between lowerBound: Date, and upperBound: Date) -> IssueQualifier {
        return .init(rawValue: "closed:\(lowerBound.iso8601)..\(upperBound.iso8601)")
    }

    static func closed(in range: ClosedRange<Date>) -> IssueQualifier {
        return .closed(between: range.lowerBound, and: range.upperBound)
    }

    static func closed(in range: PartialRangeThrough<Date>) -> IssueQualifier {
        return .closed(beforeOrOn: range.upperBound)
    }

    static func closed(in range: PartialRangeFrom<Date>) -> IssueQualifier {
        return .closed(afterOrOn: range.lowerBound)
    }

    static func merged(on date: Date) -> IssueQualifier {
        return .init(rawValue: "merged:\(date.iso8601)")
    }

    static func merged(after date: Date) -> IssueQualifier {
        return .init(rawValue: "merged:>\(date.iso8601)")
    }

    static func merged(afterOrOn date: Date) -> IssueQualifier {
        return .init(rawValue: "merged:>=\(date.iso8601)")
    }

    static func merged(before date: Date) -> IssueQualifier {
        return .init(rawValue: "merged:<\(date.iso8601)")
    }

    static func merged(beforeOrOn date: Date) -> IssueQualifier {
        return .init(rawValue: "merged:<=\(date.iso8601)")
    }

    static func merged(between lowerBound: Date, and upperBound: Date) -> IssueQualifier {
        return .init(rawValue: "merged:\(lowerBound.iso8601)..\(upperBound.iso8601)")
    }

    static func merged(in range: ClosedRange<Date>) -> IssueQualifier {
        return .merged(between: range.lowerBound, and: range.upperBound)
    }

    static func merged(in range: PartialRangeThrough<Date>) -> IssueQualifier {
        return .merged(beforeOrOn: range.upperBound)
    }

    static func merged(in range: PartialRangeFrom<Date>) -> IssueQualifier {
        return .merged(afterOrOn: range.lowerBound)
    }
}

// MARK: Support qualifying on merged and unmerged pull requests

public extension IssueQualifier {
    enum MergeState: String {
        case merged
        case unmerged
    }

    static func `is`(_ merged: MergeState) -> IssueQualifier {
        return .init(rawValue: "is:\(merged.rawValue)")
    }
}

// MARK: Support qualifying based on whether a repo is archived

extension IssueQualifier: ArchivedQualifiable {}

// MARK: Support qualifying based on missing metadata

public extension IssueQualifier {
    enum IssueMetadata: String {
        case label
        case milestone
        case assignee
        case project
    }

    static func no(_ metadata: IssueMetadata) -> IssueQualifier {
        return .init(rawValue: "no:\(metadata.rawValue)")
    }
}
