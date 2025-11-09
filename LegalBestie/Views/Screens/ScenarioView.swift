// ScenarioView displays a step-by-step legal scenario loaded from a JSON file.
// It shows questions with choices or outcomes based on user input.

/*

import SwiftUI
import WebKit
import Foundation

struct WebPreviewView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct ScenarioView: View {
    let scenario: Scenario // The full scenario loaded from a JSON file
    
    // The ID of the current node (e.g., "q1", "q2", etc.)
    @State private var currentNodeId: String
    // The actual node being displayed
    @State private var currentNode: ScenarioNode?
    
    // Initialize the view with a scenario and set the starting node
    init(scenario: Scenario) {
        self.scenario = scenario
        _currentNodeId = State(initialValue: scenario.startNode) // From JSON: the ID where the scenario starts
        _currentNode = State(initialValue: scenario.nodes[scenario.startNode]) // Loads the node object from the dictionary
    }
    
var body: some View {
  VStack(alignment: .leading, spacing: 24) {
  if let node = currentNode {
  if node.type == "outcome" {
      
  // If the node is an outcome, show the result screen with legal summary
  ScenarioOutcomeView(
  title: node.title ?? "Outcome",
  description: node.description ?? "",
  legalSummary: node.legalSummary
  )
  } else {
  // If the node is a question, show the question and multiple choice buttons
  Text(node.question ?? "")
  .font(.title2)
  .fontWeight(.medium)
  
  ForEach(node.choices ?? [], id: \.label) { choice in
  Button(action: {
  navigate(to: choice.nextNode) // On tap, go to the next node
  }) {
  Text(choice.label)
  .padding()
  .frame(maxWidth: .infinity)
  .background(Color.blue.opacity(0.8))
  .foregroundColor(.white)
  .cornerRadius(10)
  }
  }
  }
  } else {
  // If something went wrong loading the node
  Text("Error loading scenario node.")
  .foregroundColor(.red)
  }
  
  Spacer()
  }
  .padding()
  //.navigationTitle(scenario.title) // Shows scenario title from JSON
  
  Divider()
  
  // Add this to test loading LegalSourceViewModel
  LegalSourcesSection()
  }
  
  // Updates the view to show the node with the given ID
  func navigate(to nextId: String) {
  currentNodeId = nextId
  currentNode = scenario.nodes[nextId]
  }
  }
  
  struct LegalSourcesSection: View {
  @StateObject private var sourceViewModel = LegalSourceViewModel()
  
  var body: some View {
  VStack(alignment: .leading, spacing: 12) {
  Text("📚 Legal Sources")
  .font(.title3)
  .bold()
  
  ForEach(sourceViewModel.sources) { source in
  NavigationLink(destination: WebPreviewView(url: URL(string: source.url)!)) {
  VStack(alignment: .leading, spacing: 6) {
  Text(source.title)
  .font(.headline)
  Text(source.description)
  .font(.subheadline)
  .foregroundColor(.secondary)
  Text("🔗 \(source.organization) • \(source.status)")
  .font(.caption)
  .foregroundColor(.gray)
  }
  .padding()
  .background(Color(.secondarySystemBackground))
  .cornerRadius(8)
  }
  }
  }
  .padding(.top)
  }
  }


ScenarioView — temporary compiling stub so you can keep building while you wire Firebase/Auth.
The full step-by-step UI you had is preserved in git history; reintroduce it piece‑by‑piece later.

import SwiftUI
import WebKit
import Foundation

// If you still need a web preview for legal links later
struct WebPreviewView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct ScenarioView: View {
    // Keep the API surface but make the parameter optional so this view can be previewed/used without data.
    let scenario: Scenario?

    init(scenario: Scenario? = nil) {
        self.scenario = scenario
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Scenario View")
                .font(.title2)
                .fontWeight(.semibold)
            if let scenario = scenario {
                Text("Loaded: \(scenario.scenarioTitle)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text("No scenario provided yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
} */
