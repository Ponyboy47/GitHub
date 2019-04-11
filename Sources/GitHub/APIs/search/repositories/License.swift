import struct Foundation.URL

public struct License: Decodable, Hashable {
    public let key: SupportedLicense
    public let name: String
    public let spdxID: String
    public let url: URL?
    public let nodeID: String

    enum CodingKeys: String, CodingKey {
        case key
        case name
        case spdxID = "spdx_id"
        case url
        case nodeID = "node_id"
    }
}
