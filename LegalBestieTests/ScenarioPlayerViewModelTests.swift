//
//  ScenarioPlayerViewModelTests.swift
//  LegalBestieTests
//
//  Created by Carolina LC on 10/09/2026.

import Foundation
import XCTest //framework, same as NUnit
@testable import LegalBestie //grants widened visibility

@MainActor
//XCTest is the base class
final class ScenarioPlayerViewModelTests: XCTestCase {
    
    private var sut: ScenarioPlayerViewModel!
    
    //every test gets a fresh SPVM
    override func setUp() {
        super.setUp()
        //arrange
        sut = ScenarioPlayerViewModel(category: "civil_rights", name: "stopped_by_police")
    }
    
    //cleanup before next test
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_convertToStatement_shouldReturnPastTenseStatement_whenAnswerIsYes() {
        
        //act-call the function
        let result = sut.convertToStatement(
            question: "Did the officer ask for ID?",
            answer: "yes"
        )
        print(result)
        
        //assert-expect result
        XCTAssertEqual(result, "The officer asked for ID")
    }
    
    func test_convertToStatement_shouldNegateStatementwhenAnswerIsNo() {
        
        let result = sut.convertToStatement(
            question: "Did the officer ask for ID?",
            answer: "no"
        )
        print(result)
        XCTAssertEqual(result, "The officer did not ask for ID")
    }
    
    func test_selectChoice_shouldAdvanceCorrectKey_andRecordTheAnswer() {
        sut.template = Self.makeTemplate()
        sut.currentKey = "start"
        sut.selectChoice(
            question: "Where you stopped by police?",
            answer: "yes",
            nextNode: "askedForId"
        )
        
        XCTAssertEqual(sut.currentKey, "askedForId")
        XCTAssertEqual(sut.userResponses.count, 1)
        XCTAssertEqual(sut.userResponses.first?.answer, "yes")
    }
    
    private static func makeTemplate() -> ScenarioTemplate {
        ScenarioTemplate(
            scenarioId: "stopped_by_police",
            scenarioTitle: "Stopped by the police",
            categoryName: "civil_rights",
            scenarioDescription: "Test scenario",
            startNode: "start",
            nodes: [
                "start": ScenarioNode(
                    stepId: "start",
                    question: "Where you stopped by police?",
                    choices: [
                        Choice(label: "Yes", nextNode: "askedForID"),
                        Choice(label: "No", nextNode: "outcome")
                    ],
                    type: nil,
                    stepOutcome: nil,
                    nextStepID: nil,
                    isRequired: false,
                    updatedAt: nil
                )
            ],
            legalSummaryText: "Test summary",
            legalSources: nil,
            scenarioUpdatedAt: nil,
            scenarioTopics: ["stop and search"]
        )
    }
}
