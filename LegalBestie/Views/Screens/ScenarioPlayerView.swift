import SwiftUI


struct ScenarioPlayerView: View {
    let category: String
    let name: String

    @StateObject private var viewModel = ScenarioViewModel()

    var body: some View {
        List {
            ForEach(viewModel.scenarios) { scenario in
                NavigationLink {
                    ScenarioPlayerView(
                        category: category,
                        name: scenario.fileName
                    )
                } label: {
                    Text(scenario.title)
                }
            }
        }
    }
}
