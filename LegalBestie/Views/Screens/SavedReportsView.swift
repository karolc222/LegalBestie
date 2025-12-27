//
//  SavedReportsView.swift
//  LegalBestie
//
//  Created by Carolina LC on 18/11/2025.
//

import Foundation
import SwiftUI

// Simple SavedReports list view
struct SavedReportsView: View {
    var body: some View {
        List {
            Text("Your saved reports will appear here")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Saved Reports")
    }
}
