import struct Foundation.Date

public struct RepositoryQualifier: SearchQualifier {
    public static let sizeKey: KeyPath<ByteSize, Int> = \ByteSize.kilobytes

    public var _qualifiers = Set<String>()

    public init() {}
}

// MARK: Support 'in:qualifier'

extension RepositoryQualifier: InQualifiable {
    public enum InQualifier: String {
        case name
        case description
        case readme
        case nameOrDescription = "name,description"
    }
}

// MARK: Support user and organization qualifiers

extension RepositoryQualifier: UserQualifiable {}
extension RepositoryQualifier: OrganizationQualifiable {}

// MARK: Support repository size qualifiers

extension RepositoryQualifier: ByteSizeQualifiable {}

// MARK: Support forks qualifiers

public extension RepositoryQualifier {
    static func forks(equals forks: Int) -> RepositoryQualifier {
        return .init(rawValue: "forks:\(forks)")
    }

    static func forks(greaterThan forks: Int) -> RepositoryQualifier {
        return .init(rawValue: "forks:>\(forks)")
    }

    static func forks(greaterThanOrEqualTo forks: Int) -> RepositoryQualifier {
        return .init(rawValue: "forks:>=\(forks)")
    }

    static func forks(lessThan forks: Int) -> RepositoryQualifier {
        return .init(rawValue: "forks:<\(forks)")
    }

    static func forks(lessThanOrEqualTo forks: Int) -> RepositoryQualifier {
        return .init(rawValue: "forks:<=\(forks)")
    }

    static func forks(between lowerBound: Int, and upperBound: Int) -> RepositoryQualifier {
        return .init(rawValue: "forks:\(lowerBound)..\(upperBound)")
    }

    static func forks(in range: ClosedRange<Int>) -> RepositoryQualifier {
        return .forks(between: range.lowerBound, and: range.upperBound)
    }

    static func forks(in range: PartialRangeThrough<Int>) -> RepositoryQualifier {
        return .forks(lessThanOrEqualTo: range.upperBound)
    }

    static func forks(in range: PartialRangeFrom<Int>) -> RepositoryQualifier {
        return .forks(greaterThanOrEqualTo: range.lowerBound)
    }
}

// MARK: Support stars qualifiers

public extension RepositoryQualifier {
    static func stars(equals stars: Int) -> RepositoryQualifier {
        return .init(rawValue: "stars:\(stars)")
    }

    static func stars(greaterThan stars: Int) -> RepositoryQualifier {
        return .init(rawValue: "stars:>\(stars)")
    }

    static func stars(greaterThanOrEqualTo stars: Int) -> RepositoryQualifier {
        return .init(rawValue: "stars:>=\(stars)")
    }

    static func stars(lessThan stars: Int) -> RepositoryQualifier {
        return .init(rawValue: "stars:<\(stars)")
    }

    static func stars(lessThanOrEqualTo stars: Int) -> RepositoryQualifier {
        return .init(rawValue: "stars:<=\(stars)")
    }

    static func stars(between lowerBound: Int, and upperBound: Int) -> RepositoryQualifier {
        return .init(rawValue: "stars:\(lowerBound)..\(upperBound)")
    }

    static func stars(in range: ClosedRange<Int>) -> RepositoryQualifier {
        return .stars(between: range.lowerBound, and: range.upperBound)
    }

    static func stars(in range: PartialRangeThrough<Int>) -> RepositoryQualifier {
        return .stars(lessThanOrEqualTo: range.upperBound)
    }

    static func stars(in range: PartialRangeFrom<Int>) -> RepositoryQualifier {
        return .stars(greaterThanOrEqualTo: range.lowerBound)
    }
}

// MARK: Support created qualifiers

extension RepositoryQualifier: CreatedQualifiable {}

// MARK: Support pushed qualifiers

public extension RepositoryQualifier {
    static func pushed(on date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:\(date.iso8601)")
    }

    static func pushed(after date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:>\(date.iso8601)")
    }

    static func pushed(afterOrOn date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:>=\(date.iso8601)")
    }

    static func pushed(before date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:<\(date.iso8601)")
    }

    static func pushed(beforeOrOn date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:<=\(date.iso8601)")
    }

    static func pushed(between lowerBound: Date, and upperBound: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:\(lowerBound.iso8601)..\(upperBound.iso8601)")
    }

    static func pushed(in range: ClosedRange<Date>) -> RepositoryQualifier {
        return .pushed(between: range.lowerBound, and: range.upperBound)
    }

    static func pushed(in range: PartialRangeThrough<Date>) -> RepositoryQualifier {
        return .pushed(beforeOrOn: range.upperBound)
    }

    static func pushed(in range: PartialRangeFrom<Date>) -> RepositoryQualifier {
        return .pushed(afterOrOn: range.lowerBound)
    }

    static func updated(on date: Date) -> RepositoryQualifier {
        return .pushed(on: date)
    }

    static func updated(after date: Date) -> RepositoryQualifier {
        return .pushed(after: date)
    }

    static func updated(afterOrOn date: Date) -> RepositoryQualifier {
        return .pushed(afterOrOn: date)
    }

    static func updated(before date: Date) -> RepositoryQualifier {
        return .pushed(before: date)
    }

    static func updated(beforeOrOn date: Date) -> RepositoryQualifier {
        return .pushed(beforeOrOn: date)
    }

    static func updated(between lowerBound: Date, and upperBound: Date) -> RepositoryQualifier {
        return .pushed(between: lowerBound, and: upperBound)
    }

    static func updated(in range: ClosedRange<Date>) -> RepositoryQualifier {
        return .pushed(in: range)
    }

    static func updated(in range: PartialRangeThrough<Date>) -> RepositoryQualifier {
        return .pushed(in: range)
    }

    static func updated(in range: PartialRangeFrom<Date>) -> RepositoryQualifier {
        return .pushed(in: range)
    }
}

// MARK: Support language qualifiers

extension RepositoryQualifier: LanguageQualifiable {}

// MARK: Support topic qualifiers

public extension RepositoryQualifier {
    static func topic(_ topic: String) -> RepositoryQualifier {
        return .init(rawValue: "topic:\(topic)")
    }

    static func topics(equals topics: Int) -> RepositoryQualifier {
        return .init(rawValue: "topics:\(topics)")
    }

    static func topics(greaterThan topics: Int) -> RepositoryQualifier {
        return .init(rawValue: "topics:>\(topics)")
    }

    static func topics(greaterThanOrEqualTo topics: Int) -> RepositoryQualifier {
        return .init(rawValue: "topics:>=\(topics)")
    }

    static func topics(lessThan topics: Int) -> RepositoryQualifier {
        return .init(rawValue: "topics:<\(topics)")
    }

    static func topics(lessThanOrEqualTo topics: Int) -> RepositoryQualifier {
        return .init(rawValue: "topics:<=\(topics)")
    }

    static func topics(between lowerBound: Int, and upperBound: Int) -> RepositoryQualifier {
        return .init(rawValue: "topics:\(lowerBound)..\(upperBound)")
    }

    static func topics(in range: ClosedRange<Int>) -> RepositoryQualifier {
        return .topics(between: range.lowerBound, and: range.upperBound)
    }

    static func topics(in range: PartialRangeThrough<Int>) -> RepositoryQualifier {
        return .topics(lessThanOrEqualTo: range.upperBound)
    }

    static func topics(in range: PartialRangeFrom<Int>) -> RepositoryQualifier {
        return .topics(greaterThanOrEqualTo: range.lowerBound)
    }
}

// MARK: Support 'license:qualifier'

public enum SupportedLicense: String, Decodable, Hashable {
    case aflv3 = "afl-3.0"
    public static let academicFreeLicense_v3 = SupportedLicense.aflv3
    case apachev2 = "apache-2.0"
    case artisticv2 = "artistic-2.0"
    case bslv1 = "bsl-1.0"
    public static let boostSoftwareLicense_v1 = SupportedLicense.bslv1
    case bsd2Clause = "bsd-2-clause"
    case bsd3Clause = "bsd-3-clause"
    case bsd3ClauseClear = "bsd-3-clause-clear"
    case cc
    public static let creativeCommonsLicenseFamily = SupportedLicense.cc
    case cc0v1 = "cc0-1.0"
    public static let creativeCommonsZero_v1 = SupportedLicense.cc0v1
    case ccByv4 = "cc-by-4.0"
    public static let creativeCommonsAttribution_v4 = SupportedLicense.ccByv4
    case ccBySAv4 = "cc-by-sa-4.0"
    public static let creativeCommonsAttributionShareAlike_v4 = SupportedLicense.ccBySAv4
    case wtfpl
    public static let doWhatTheF_ckYouWantTo = SupportedLicense.wtfpl
    case eclv2 = "ecl-2.0"
    public static let educationalComunityLicense_v2 = SupportedLicense.eclv2
    case eplv1 = "epl-1.0"
    public static let eclipsePublicLicense_v1 = SupportedLicense.eplv1
    case euplv1_1 = "eupl-1.1"
    public static let europeanUnionPublicLicense_v1_1 = SupportedLicense.euplv1_1
    case agplv3 = "agpl-3.0"
    public static let gnuAfferoGeneralPublicLicense_v3 = SupportedLicense.agplv3
    case gpl
    public static let gnuGeneralPublicLicenseFamily = SupportedLicense.gpl
    case gplv2 = "gpl-2.0"
    public static let gnuGeneralPublicLicense_v2 = SupportedLicense.gplv2
    case gplv3 = "gpl-3.0"
    public static let gnuGeneralPublicLicense_v3 = SupportedLicense.gplv3
    case lgpl
    public static let gnuLesserGeneralPublicLicenseFamily = SupportedLicense.gpl
    case lgplv2_1 = "lgpl-2.1"
    public static let gnuLesserGeneralPublicLicense_v2_1 = SupportedLicense.lgplv2_1
    case lgplv3 = "lgpl-3.0"
    public static let gnuLesserGeneralPublicLicense_v3 = SupportedLicense.lgplv3
    case isc
    case lpplv1_3c = "lppl-1.3c"
    public static let laTeXProjectPublicLicense_v1_3c = SupportedLicense.lpplv1_3c
    case mspl = "ms-pl"
    public static let microsoftPublicLicense = SupportedLicense.mspl
    case mit
    case mplv2 = "mpl-2.0"
    public static let mozillaPublicLicense_v2 = SupportedLicense.mplv2
    case oslv3 = "osl-3.0"
    public static let openSoftwareLicense_v3 = SupportedLicense.oslv3
    case postgresql
    case oflv1_1 = "ofl-1.1"
    public static let silOpenFontLicense_v1_1 = SupportedLicense.oflv1_1
    case ncsa
    public static let universityOfIllinoisOpenSourceLicense = SupportedLicense.ncsa
    public static let ncsaOpenSourceLicense = SupportedLicense.ncsa
    case unlicense
    case zlib

    case other
}

public extension RepositoryQualifier {
    static func license(_ license: SupportedLicense) -> RepositoryQualifier {
        return .init(rawValue: "license:\(license.rawValue)")
    }
}

// MARK: Support qualifier for public or private repos

extension RepositoryQualifier: PublicPrivateQualifiable {}

// MARK: Support qualifier for mirrors

public extension RepositoryQualifier {
    static func mirror(_ mirror: Bool) -> RepositoryQualifier {
        return .init(rawValue: "mirror:\(mirror)")
    }
}

// MARK: Support qualifier for archived repos

extension RepositoryQualifier: ArchivedQualifiable {}

// MARK: Support qualifiers for minimum number of issues with helpful labels

public extension RepositoryQualifier {
    static func goodFirstIssues(greaterThan count: Int) -> RepositoryQualifier {
        return .init(rawValue: "good-first-issues:>\(count)")
    }

    static func helpWantedIssues(greaterThan count: Int) -> RepositoryQualifier {
        return .init(rawValue: "help-wanted-issues:>\(count)")
    }
}
