//  SourcesProvider.swift
//  LegalBestie
//
//  Created by Carolina LC on 21/12/2025.

import Foundation

final class SourcesProvider {

    typealias SourcePair = (sourceTitle: String, sourceDescription: String)
    
    //loads the json file with local sources/gov.uk search service
    private let localSourcesVM = LegalSourceViewModel()
    private let govUK = GovUKSearchService()

    // cached value: question + date + source
    private var cache: [String: (Date, [SourcePair])] = [:]
    
    //how long the question will be cached = 30 mins
    private let ttl: TimeInterval = 30 * 60

    func sources(for question: String) async throws -> [SourcePair] {
        let q = question.trimmingCharacters(in:
                .whitespacesAndNewlines)
        guard !q.isEmpty else { return [] }

        var pairs = localSources(matching: q.lowercased())

        if pairs.count < 3 {
            let govPairs = try await govUKPairs(query: q)
            pairs.append(contentsOf: govPairs)
        }

        return Array(dedupe(pairs).prefix(6))
    }

    private func localSources(matching q: String) -> [SourcePair] {
        if localSourcesVM.sources.isEmpty { localSourcesVM.loadSources() }
        
        let queryLower = q.lowercased()
        
        // Try exact phrase match first
        let exactMatches = localSourcesVM.sources.filter { src in
            src.sourceTitle.lowercased().contains(queryLower) ||
            src.sourceDescription.lowercased().contains(queryLower)
        }
        
        if !exactMatches.isEmpty {
            return exactMatches.prefix(6).map {
                let url = $0.sourceUrl.isEmpty ? "" : "\nURL: \($0.sourceUrl)"
                return ($0.sourceTitle, $0.sourceDescription + url)
            }
        }
        
        // Fall back to keyword matching
        let tokens = Set(q.split { !($0.isLetter || $0.isNumber) }
            .map { String($0).lowercased() }
            .filter { $0.count >= 3 })
        
        guard !tokens.isEmpty else { return [] }
        
        let matches = localSourcesVM.sources.filter { src in
            let allKeywords = (src.sourceKeywords + src.sourceTopics).map { $0.lowercased() }
            return allKeywords.contains { keyword in
                tokens.contains(keyword) || keyword.contains(where: { tokens.contains(String($0)) })
            }
        }
        
        guard !matches.isEmpty else { return [] }
        
        return matches.prefix(6).map {
            let url = $0.sourceUrl.isEmpty ? "" : "\nURL: \($0.sourceUrl)"
            return ($0.sourceTitle, $0.sourceDescription + url)
        }
    }
    private func govUKPairs(query: String) async throws -> [SourcePair] {
        let key = query.lowercased()
        if let (time, value) = cache[key], Date().timeIntervalSince(time) < ttl {
            return value
        }

        let results = try await govUK.search(query, count: 5)
        let pairs: [SourcePair] = results.compactMap {
            guard $0.link.hasPrefix("https://www.gov.uk/") else { return nil }
            let desc = ($0.description ?? "") + "\nURL: \($0.link)"
            return ("GOV.UK: \($0.title)", desc)
        }

        cache[key] = (Date(), pairs)
        return pairs
    }

    private func dedupe(_ pairs: [SourcePair]) -> [SourcePair] {
        var seen = Set<String>()
        return pairs.filter {
            let k = ($0.sourceTitle + "\n" + $0.sourceDescription).lowercased()
            return seen.insert(k).inserted
        }
    }
}
