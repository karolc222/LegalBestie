import SwiftUI

struct LegalSummaryView: View {
    let title: String
    let explanation: String
    let law: String
    let section: String
    let concept: String
    let link: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📘 Legal Summary").font(.title2).bold()
            Text(explanation)
            Divider()
            Text("📜 Law: \(law)").bold()
            Text("Section: \(section)")
            Text("🔍 \(concept)").italic()
            Link("View Full Law", destination: URL(string: link)!)
        }
        .padding()
        .navigationTitle("Outcome")
    }
}
