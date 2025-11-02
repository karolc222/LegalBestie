import SwiftUI

// This is the main entry view of the app, responsible for loading and displaying a legal scenario.
struct ContentView: View {
    // Creates a shared instance of the ScenarioViewModel to load and manage the scenario data.
    // ScenarioViewModel loads 'journalists/stopped_by_police.json' from the app bundle.
    @StateObject private var viewModel = ScenarioViewModel()

    var body: some View {
        NavigationView {
            // If the scenario is successfully loaded, show the interactive scenario view.
            if let scenario = viewModel.scenario {
                // ScenarioView displays the question/answer tree using the loaded scenario.
                // It relies on models defined in Scenario.swift (Scenario, ScenarioNode, Choice, etc.)
                //ScenarioView(scenario: scenario)
            } else {
                // Show a loading indicator while the scenario is being loaded.
                ProgressView("Loading scenario...")
            }
        }
    }
}

