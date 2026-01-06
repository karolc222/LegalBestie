import Foundation

final class ScenarioService {

    func startScenario(
        scenarioId: String,
        scenarioTitle: String,
        userId: String
    ) -> ScenarioReport {
        ScenarioReport(
            userId: userId,
            scenarioId: scenarioId,
            scenarioTitle: scenarioTitle,
            createdAt: Date(),
            steps: [],
            legalSummary: "",
            legalSources: []
        )
    }

    func recordStep(
        report: ScenarioReport,
        statement: String,
        stepNumber: Int
    ) {
        report.steps.append(
            StepReport(
                stepNumber: stepNumber,
                statement: statement
            )
        )
    }

    func completeScenario(
        report: ScenarioReport,
        legalSummary: String,
        legalSources: [ScenarioSourceDTO]
    ) {
        report.legalSummary = legalSummary
        report.legalSources = legalSources
    }
}

