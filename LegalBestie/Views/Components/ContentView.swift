import SwiftUI

// loads and displays a legal scenario

struct ContentView: View {
    @StateObject private var viewModel = ScenarioViewModel()

    var body: some View {
        NavigationView {
            if let _ = viewModel.scenario {
                Text("Scenario loaded")
            } else {
                ProgressView("Loading scenario...")
            }
        }
    }
}
