//
//  LegalSource.swift
//  LegalBestie
//

import Foundation
import SwiftData

@Model
final class LegalSource {
    @Attribute(.unique) var id: String
    var title: String
    var url: String
    //var description: String
    var organization: String
    var status: String
    var keywords: [String]

    init(
        id: String = UUID().uuidString,
        title: String,
        url: String,
        description: String,
        organization: String,
        status: String,
        keywords: [String]
    ) {
        self.id = id
        self.title = title
        self.url = url
        //self.description = description
        self.organization = organization
        self.status = status
        self.keywords = keywords
    }
}
