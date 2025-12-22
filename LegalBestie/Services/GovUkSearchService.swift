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
    func search(_ query: String, count: Int = 5) async throws -> [GovUKSearchResponse.Result] {
        var comps = URLComponents(string: "https://www.gov.uk/api/search.json")!
        comps.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "count", value: "\(count)")
        ]

        // Sends an HTTP GET request to the GOV.UK Search API endpoint
        let (data, response) = try await URLSession.shared.data(from: comps.url!)
        
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let raw = String(data: data, encoding: .utf8) ?? "<no body>"
            throw NSError(domain: "GovUK", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "GOV.UK search error \(http.statusCode): \(raw)"])
        }

        // Decodes the JSON response into strongly typed search results
        return try JSONDecoder().decode(GovUKSearchResponse.self, from: data).results
    }
}
