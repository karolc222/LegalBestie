import Foundation

struct GovUKSearchResponse: Decodable {

    struct Result: Decodable {
        let title: String
        let link: String
        let description: String?
    }

    let results: [Result]
}

@MainActor
final class GovUKSearchService {

    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "User-Agent": "LegalBestie/1.0 (iOS; SwiftUI)"
        ]
        self.session = URLSession(configuration: config)
    }

    func search(_ query: String, count: Int = 5) async throws -> [GovUKSearchResponse.Result] {

        var components = URLComponents(string: "https://www.gov.uk/api/search.json")!
        components.queryItems = [
            .init(name: "q", value: query),
            .init(name: "count", value: "\(count)")
        ]

        let request = URLRequest(url: components.url!)

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw GovUKError.network
        }

        guard (200...299).contains(http.statusCode) else {
            throw GovUKError.http(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(GovUKSearchResponse.self, from: data).results
        } catch {
            throw GovUKError.decode
        }
    }
}

enum GovUKError: LocalizedError {
    case network
    case http(Int)
    case decode

    var errorDescription: String? {
        switch self {
        case .network:
            return "Network error."
        case .http(let code):
            return "GOV.UK request failed (\(code))."
        case .decode:
            return "GOV.UK response could not be decoded."
        }
    }
}
