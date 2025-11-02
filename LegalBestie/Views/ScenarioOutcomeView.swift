import SwiftUI

struct ScenarioOutcomeView: View {
    let title: String
    let description: String
    //let legalSummary: LegalSummary?
    
    var body: some View {
        ScrollView {
            LegalSummaryView(
                title: "PACE – Stop and Search",
                explanation: "Under UK law, police must provide a legal reason when stopping someone. Failure to do so may be unlawful.",
                law: "Police and Criminal Evidence Act 1984",
                section: "Section 2: Information to be given before search",
                concept: "Protects individuals from arbitrary stop-and-search actions by requiring legal justification.",
                link: "https://www.legislation.gov.uk/ukpga/1984/60"
            )
        }
    }
}
