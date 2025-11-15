//  README.md.swift
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.


LegalBestie – UK Legal Knowledge App (MSc Software Engineering Project)

LegalBestie is an iOS application built with SwiftUI, SwiftData, and OpenAI APIs that helps users understand practical legal rights in everyday scenarios (e.g., police encounters, renting issues, immigration contexts).
The app presents interactive legal scenarios, step-by-step decision trees, and verified legal sources to make legal information clear, accessible, and engaging.

⸻

🚀 Core Features

1. Interactive Legal Scenarios
    •    Stored as .json files inside the app bundle
    •    Each scenario functions as a decision tree with:
    •    Questions
    •    Choices
    •    Nodes leading to other nodes
    •    Summary text and verified legal sources

2. Category-Based Scenario Browser
    •    Users select a category (e.g., civil rights, immigration, renters)
    •    Scenario list loads automatically from embedded JSON files
    •    Clean UI with scenario title, description, and last update date

3. In-App Scenario Player
    •    Fully interactive
    •    Displays questions, choices, outcomes, and summaries
    •    Lightweight: no backend needed
    •    Decodes JSON at runtime using a custom UK date format

4. Modular Architecture
    •    Organized into App, Data, Features, Models, Services, ViewModels, and Views
    •    Easy to extend with new scenarios or categories
    •    JSON format is clean and human-editable

LegalBestie/
│
├── App/
├── Data/
├── Features/
├── Models/
├── Resources/
│   └── JSON/
│       ├── civil_rights/
│       │   └── stopped_by_police.json
│       ├── immigrants/
│       └── renters/
├── Services/
├── ViewModels/
└── Views/
