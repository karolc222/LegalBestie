//
//  GovUkSearchService.swift
//  LegalBestie
//
//  Created by Carolina LC on 21/12/2025.
//  API layer

import Foundation

struct GovUKSearchResponse: Decodable {
    
    struct Result: Decodable {
        let title: String
        let link: String
        let description: String?
    }
    let results: [Result]
}

final class GovUKSearchService {
    private let session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        // Avoid weird compression/protocol issues when possible
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Accept-Encoding": "identity",
            "User-Agent": "LegalBestie/1.0 (iOS; SwiftUI)"
        ]
        return URLSession(configuration: config)
    }()
    func search(_ query: String, count: Int = 5) async throws -> [GovUKSearchResponse.Result] {
        var comps = URLComponents(string: "https://www.gov.uk/api/search.json")!
        comps.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "count", value: "\(count)")
        ]

        var request = URLRequest(url: comps.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("identity", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("LegalBestie/1.0 (iOS; SwiftUI)", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await session.data(for: request)
        
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let raw = String(data: data, encoding: .utf8) ?? "<no body>"
            throw NSError(domain: "GovUK", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "GOV.UK search error \(http.statusCode): \(raw)"])
        }

        if let http = response as? HTTPURLResponse {
            let mime = http.mimeType ?? ""
            if !mime.contains("json") {
                let raw = String(data: data, encoding: .utf8) ?? "<no body>"
                throw NSError(
                    domain: "GovUK",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "GOV.UK returned non-JSON (\(mime)). Body: \(raw.prefix(300))"]
                )
            }
        }

        do {
            return try JSONDecoder().decode(GovUKSearchResponse.self, from: data).results
        } catch {
            let raw = String(data: data, encoding: .utf8) ?? "<no body>"
            print("GovUK decode failed: \(error). Raw: \(raw.prefix(400))")
            throw NSError(
                domain: "GovUK",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "GOV.UK response could not be decoded."]
            )
        }
    }
}
