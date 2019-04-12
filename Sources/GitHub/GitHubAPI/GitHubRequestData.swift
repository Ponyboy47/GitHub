import HTTP

public protocol GitHubRequestData {}

extension HTTPBody: GitHubRequestData {}
public struct URLQuery: GitHubRequestData {
    private var query: String = ""

    public mutating func add<T: RawRepresentable>(option key: String, value: T) where T.RawValue == String {
        add(option: key, value: value.rawValue)
    }

    public mutating func add(option key: String, value: String) {
        if !query.isEmpty {
            query += "&"
        }

        query += "\(key)=\(value)"
    }

    public mutating func add(flag: String, if bool: Bool) {
        guard bool else { return }

        if !query.isEmpty {
            query += "&"
        }
        query += flag
    }

    func url(base: String, page: Int?, perPage: Int?) -> String {
        var paging = ""
        if page != nil || perPage != nil, !query.isEmpty {
            paging += "&"
        }

        if let page = page {
            paging += "page=\(page)"
        }
        if let perPage = perPage {
            if paging.count > 1 {
                paging += "&"
            }
            paging += "per_page=\(perPage)"
        }

        if !query.isEmpty {
            return "\(base)?\(query)\(paging)"
        } else if !paging.isEmpty {
            return "\(base)?\(paging)"
        }
        return base
    }
}
