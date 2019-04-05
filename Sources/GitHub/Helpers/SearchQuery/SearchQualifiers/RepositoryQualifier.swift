import struct Foundation.Date

public struct RepositoryQualifier: SearchQualifier {
    public var _qualifiers = Set<String>()

    public init() {}
}

// MARK: Support 'in:qualifier'
public extension RepositoryQualifier {
    enum InQualifier: String {
        case name
        case description
        case readme
        case nameOrDescription = "name,description"
    }

    static func `in`(_ qualifier: InQualifier) -> RepositoryQualifier {
        return .init(rawValue: "in:\(qualifier.rawValue)")
    }
}

// MARK: Support user and organization qualifiers
public extension RepositoryQualifier {
    static func user(_ username: String) -> RepositoryQualifier {
        return .init(rawValue: "user:\(username)")
    }

    static func organization(_ organization: String) -> RepositoryQualifier {
        return .init(rawValue: "org:\(organization)")
    }
}

// MARK: Support repository size qualifiers
public extension RepositoryQualifier {
    enum Size: RawRepresentable, ExpressibleByIntegerLiteral, Comparable {
        public var rawValue: Int {
            switch self {
            case .bytes(let value): return value / 1024
            case .kilobytes(let value): return value
            case .megabytes(let value): return value * 1024
            case .gigabytes(let value): return value * 1024 * 1024
            }
        }

        case bytes(Int)
        case kilobytes(Int)
        case megabytes(Int)
        case gigabytes(Int)

        public init(rawValue: Int) {
            self = .kilobytes(rawValue)
        }
        public init(integerLiteral value: Int) {
            self.init(rawValue: value)
        }

        public static func < (lhs: Size, rhs: Size) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }

    static func size(equals size: Size) -> RepositoryQualifier {
        return .init(rawValue: "size:\(size.rawValue)")
    }
    static func size(greaterThan size: Size) -> RepositoryQualifier {
        return .init(rawValue: "size:>\(size.rawValue)")
    }
    static func size(greaterThanOrEqualTo size: Size) -> RepositoryQualifier {
        return .init(rawValue: "size:>=\(size.rawValue)")
    }
    static func size(lessThan size: Size) -> RepositoryQualifier {
        return .init(rawValue: "size:<\(size.rawValue)")
    }
    static func size(lessThanOrEqualTo size: Size) -> RepositoryQualifier {
        return .init(rawValue: "size:<=\(size.rawValue)")
    }
    static func size(between lowerBound: Size, and upperBound: Size) -> RepositoryQualifier {
        return .init(rawValue: "size:\(lowerBound.rawValue)..\(upperBound.rawValue)")
    }
    static func size(in range: ClosedRange<Size>) -> RepositoryQualifier {
        return .size(between: range.lowerBound, and: range.upperBound)
    }
    static func size(in range: PartialRangeThrough<Size>) -> RepositoryQualifier {
        return .size(lessThanOrEqualTo: range.upperBound)
    }
    static func size(in range: PartialRangeFrom<Size>) -> RepositoryQualifier {
        return .size(greaterThanOrEqualTo: range.lowerBound)
    }
}

public extension Int {
    var bytes: RepositoryQualifier.Size { return .bytes(self) }
    var kilobytes: RepositoryQualifier.Size { return .kilobytes(self) }
    var megabytes: RepositoryQualifier.Size { return .megabytes(self) }
    var gigabytes: RepositoryQualifier.Size { return .gigabytes(self) }

    var b: RepositoryQualifier.Size { return bytes }
    var kb: RepositoryQualifier.Size { return kilobytes }
    var mb: RepositoryQualifier.Size { return megabytes }
    var gb: RepositoryQualifier.Size { return gigabytes }
}

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
public extension RepositoryQualifier {
    static func created(on date: Date) -> RepositoryQualifier {
        return .init(rawValue: "created:\(iso8601Formatter.string(from: date))")
    }
    static func created(after date: Date) -> RepositoryQualifier {
        return .init(rawValue: "created:>\(iso8601Formatter.string(from: date))")
    }
    static func created(afterOrOn date: Date) -> RepositoryQualifier {
        return .init(rawValue: "created:>=\(iso8601Formatter.string(from: date))")
    }
    static func created(before date: Date) -> RepositoryQualifier {
        return .init(rawValue: "created:<\(iso8601Formatter.string(from: date))")
    }
    static func created(beforeOrOn date: Date) -> RepositoryQualifier {
        return .init(rawValue: "created:<=\(iso8601Formatter.string(from: date))")
    }
    static func created(between lowerBound: Date, and upperBound: Date) -> RepositoryQualifier {
        return .init(rawValue: "created:\(iso8601Formatter.string(from: lowerBound))..\(iso8601Formatter.string(from: upperBound))")
    }
    static func created(in range: ClosedRange<Date>) -> RepositoryQualifier {
        return .created(between: range.lowerBound, and: range.upperBound)
    }
    static func created(in range: PartialRangeThrough<Date>) -> RepositoryQualifier {
        return .created(beforeOrOn: range.upperBound)
    }
    static func created(in range: PartialRangeFrom<Date>) -> RepositoryQualifier {
        return .created(afterOrOn: range.lowerBound)
    }
}

// MARK: Support pushed qualifiers
public extension RepositoryQualifier {
    static func pushed(on date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:\(iso8601Formatter.string(from: date))")
    }
    static func pushed(after date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:>\(iso8601Formatter.string(from: date))")
    }
    static func pushed(afterOrOn date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:>=\(iso8601Formatter.string(from: date))")
    }
    static func pushed(before date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:<\(iso8601Formatter.string(from: date))")
    }
    static func pushed(beforeOrOn date: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:<=\(iso8601Formatter.string(from: date))")
    }
    static func pushed(between lowerBound: Date, and upperBound: Date) -> RepositoryQualifier {
        return .init(rawValue: "pushed:\(iso8601Formatter.string(from: lowerBound))..\(iso8601Formatter.string(from: upperBound))")
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
public extension RepositoryQualifier {
    static func language(_ lang: String) -> RepositoryQualifier {
        return .init(rawValue: "language:\(lang)")
    }
}

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
public extension RepositoryQualifier {
    enum License: String {
        case aflv3 = "afl-3.0"
        public static let academicFreeLicense_v3 = License.aflv3
        case apachev2 = "apache-2.0"
        case artisticv2 = "artistic-2.0"
        case bslv1 = "bsl-1.0"
        public static let boostSoftwareLicense_v1 = License.bslv1
        case bsd2Clause = "bsd-2-clause"
        case bsd3Clause = "bsd-3-clause"
        case bsd3ClauseClear = "bsd-3-clause-clear"
        case cc
        public static let creativeCommonsLicenseFamily = License.cc
        case cc0v1 = "cc0-1.0"
        public static let creativeCommonsZero_v1 = License.cc0v1
        case ccByv4 = "cc-by-4.0"
        public static let creativeCommonsAttribution_v4 = License.ccByv4
        case ccBySAv4 = "cc-by-sa-4.0"
        public static let creativeCommonsAttributionShareAlike_v4 = License.ccBySAv4
        case wtfpl
        public static let doWhatTheF_ckYouWantTo = License.wtfpl
        case eclv2 = "ecl-2.0"
        public static let educationalComunityLicense_v2 = License.eclv2
        case eplv1 = "epl-1.0"
        public static let eclipsePublicLicense_v1 = License.eplv1
        case euplv1_1 = "eupl-1.1"
        public static let  europeanUnionPublicLicense_v1_1 = License.euplv1_1
        case agplv3 = "agpl-3.0"
        public static let gnuAfferoGeneralPublicLicense_v3 = License.agplv3
        case gpl
        public static let gnuGeneralPublicLicenseFamily = License.gpl
        case gplv2 = "gpl-2.0"
        public static let gnuGeneralPublicLicense_v2 = License.gplv2
        case gplv3 = "gpl-3.0"
        public static let gnuGeneralPublicLicense_v3 = License.gplv3
        case lgpl
        public static let gnuLesserGeneralPublicLicenseFamily = License.gpl
        case lgplv2_1 = "lgpl-2.1"
        public static let gnuLesserGeneralPublicLicense_v2_1 = License.lgplv2_1
        case lgplv3 = "lgpl-3.0"
        public static let gnuLesserGeneralPublicLicense_v3 = License.lgplv3
        case isc
        case lpplv1_3c = "lppl-1.3c"
        public static let laTeXProjectPublicLicense_v1_3c = License.lpplv1_3c
        case mspl = "ms-pl"
        public static let microsoftPublicLicense = License.mspl
        case mit
        case mplv2 = "mpl-2.0"
        public static let mozillaPublicLicense_v2 = License.mplv2
        case oslv3 = "osl-3.0"
        public static let openSoftwareLicense_v3 = License.oslv3
        case postgresql
        case oflv1_1 = "ofl-1.1"
        public static let silOpenFontLicense_v1_1 = License.oflv1_1
        case ncsa
        public static let universityOfIllinoisOpenSourceLicense = License.ncsa
        public static let ncsaOpenSourceLicense = License.ncsa
        case unlicense
        case zlib
    }

    static func license(_ license: License) -> RepositoryQualifier {
        return .init(rawValue: "license:\(license.rawValue)")
    }
}

// MARK: Support qualifier for public or private repos
public extension RepositoryQualifier {
    static var isPublic: RepositoryQualifier {
        return .init(rawValue: "is:public")
    }
    static var isPrivate: RepositoryQualifier {
        return .init(rawValue: "is:private")
    }
}

// MARK: Support qualifier for mirrors
public extension RepositoryQualifier {
    static func mirror(_ mirror: Bool) -> RepositoryQualifier {
        return .init(rawValue: "mirror:\(mirror)")
    }
}

// MARK: Support qualifier for archived repos
public extension RepositoryQualifier {
    static func archived(_ archived: Bool) -> RepositoryQualifier {
        return .init(rawValue: "archived:\(archived)")
    }
}

// MARK: Support qualifiers for minimum number of issues with helpful labels
public extension RepositoryQualifier {
    static func goodFirstIssues(greaterThan count: Int) -> RepositoryQualifier {
        return .init(rawValue: "good-first-issues:>\(count)")
    }
    static func helpWantedIssues(greaterThan count: Int) -> RepositoryQualifier {
        return .init(rawValue: "help-wanted-issues:>\(count)")
    }
}

// MARK: Support excluding qualifiers
public extension RepositoryQualifier {
    static func exclude(_ qualifier: RepositoryQualifier) -> RepositoryQualifier {
        var raw: String = ""
        for qual in qualifier._qualifiers {
            raw += "-\(qual)"
        }
        return .init(rawValue: raw)
    }
}
