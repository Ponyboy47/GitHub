public enum Association: String, Decodable, Hashable {
    case member = "MEMBER"
    case owner = "OWNER"
    case collaborator = "COLLABORATOR"
    case contributor = "CONTRIBUTOR"
    case none = "NONE"
}
