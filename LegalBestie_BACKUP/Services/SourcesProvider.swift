//  SourcesProvider.swift
//  LegalBestie
//
//  Created by Carolina LC on 21/12/2025.

import Foundation

@MainActor
final class SourcesProvider {

    typealias SourcePair = (sourceTitle: String, sourceDescription: String)
    
    private let localSourcesVM = LegalSourceViewModel()
    private let govUK = GovUKSearchService()

    // cached value: question + date + source
    private var cache: [String: (Date, [SourcePair])] = [:]
    
    //how long the question will be cached = 30 mins
    private let ttl: TimeInterval = 30 * 60

    func sources(for question: String) async throws -> [SourcePair] {
        let q = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return [] }

        var pairs = localSources(matching: q)

        if pairs.count < 3 {
            pairs += try await govUKPairs(query: q)
        }

        return Array(dedupe(pairs).prefix(6))
    }

    private func localSources(matching q: String) -> [SourcePair] {
        if localSourcesVM.sources.isEmpty { localSourcesVM.loadSources() }

        let query = q.lowercased()

        let exact = localSourcesVM.sources.filter {
            $0.sourceTitle.lowercased().contains(query) ||
            $0.sourceDescription.lowercased().contains(query)
        }

        if !exact.isEmpty {
            return exact.prefix(6).map {
                format($0.sourceTitle, $0.sourceDescription, url: $0.sourceUrl)
            }
        }

        let tokens = tokenize(query)
        guard !tokens.isEmpty else { return [] }

        let keywordMatches = localSourcesVM.sources.filter { src in
            let keywords = (src.sourceKeywords + src.sourceTopics).map { $0.lowercased() }
            return keywords.contains { kw in
                tokens.contains(kw) || tokens.contains { kw.contains($0) }
            }
        }

        return keywordMatches.prefix(6).map {
            format($0.sourceTitle, $0.sourceDescription, url: $0.sourceUrl)
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
            return format("GOV.UK: \($0.title)", $0.description ?? "", url: $0.link)
        }

        cache[key] = (Date(), pairs)
        return pairs
    }

    private func format(_ title: String, _ description: String, url: String) -> SourcePair {
        let suffix = url.isEmpty ? "" : "\nURL: \(url)"
        return (title, description + suffix)
    }

    private func tokenize(_ text: String) -> Set<String> {
        Set(
            text.split { !($0.isLetter || $0.isNumber) }
                .map { $0.lowercased() }
                .filter { $0.count >= 3 }
        )
    }

    private func dedupe(_ pairs: [SourcePair]) -> [SourcePair] {
        var seen = Set<String>()
        return pairs.filter {
            let k = ($0.sourceTitle + "\n" + $0.sourceDescription).lowercased()
            return seen.insert(k).inserted
        }
    }
}
