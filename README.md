//  README.md
//  LegalBestie
//
//  Created by Carolina LC on 15/11/2025.


LegalBestie – UK Legal Knowledge App (MSc Software Engineering Project)

LegalBestie is an iOS application built with SwiftUI, SwiftData, and OpenAI APIs that helps users understand practical legal rights in everyday scenarios (e.g., police encounters, renting issues, immigration contexts).
The app presents interactive legal scenarios, step-by-step decision trees, and verified legal sources to make legal information clear, accessible, and engaging.

-- Accessibility as a Core Component of the Rule of Law -- 

According to the principles of the Rule of Law, the law must be accessible, intelligible, and usable by ordinary people.
In reality, millions of individuals especially women, immigrants, and low-digital-literacy populations cannot access the law in any meaningful way.


-- LegalBestie addresses three critical accessibility failures: 

1. Linguistic Accessibility

The law is written in highly technical language that even native speakers struggle to understand.
For immigrant communities, limited proficiency in French or English creates a complete disconnect between legal rights and real-world protection.


2. Digital Accessibility

Most legal information exists only on government websites.
But many women, including older immigrants — cannot use a computer, navigate official portals, or identify where to find relevant laws.
When the digital interface becomes a barrier, the law becomes unreachable.

3. Epistemic Accessibility (Trusted Information)

Even with search engines or AI tools, many users cannot distinguish reliable legal sources from misleading or outdated information.
In many communities, people end up relying on unqualified “community experts” often receiving incomplete or incorrect advice.

LegalBestie bridges this gap with verified sources, simplified explanations, and scenario-based guidance, making legal rights understandable and actionable for people who traditionally lack access.

⸻

-- Motivation -- 

Growing up across multiple cultures, I repeatedly witnessed how women and immigrants struggle to defend themselves not because the law doesn’t exist, but because the law is practically inaccessible to them.

In public spaces: public transport, beaches, universities, I saw countless situations where women were harassed, filmed, or mistreated, yet remained silent because they lacked clarity about what is illegal and how to react. Vulnerability grows when information is confusing or inaccessible.

LegalBestie is my response to these experiences.
It is a tool designed to support women, immigrants, and vulnerable groups by offering practical, verified, and understandable legal information without requiring legal expertise, digital proficiency, or perfect language skills.

⸻

-- Vision Statement --

LegalBestie empowers individuals, especially women and vulnerable communities, to understand their rights, navigate real-world legal situations, and act with confidence.
Our vision is a world where no one remains silent out of fear, confusion, or lack of information.
By transforming legal knowledge into clear, accessible, and actionable guidance, LegalBestie helps every user reclaim authority, safety, and independence.

⸻

Core Features

1. Interactive Legal Scenarios
    •    Stored as .json files inside the app bundle
    •    Each scenario functions as a decision tree with:
    •    Questions
    •    Choices
    •    Nodes leading to other nodes
    •    Summary text and verified legal sources

2. Category-Based Scenario Browser
    •    Users select a category (e.g., civil rights, immigration, renting)
    •    Scenario list loads automatically from embedded JSON files
    •    Clean UI with scenario title, description, and last update date

3. In-App Scenario Player
    •    Fully interactive
    •    Displays questions, choices, outcomes, and summaries
    •    Decodes JSON at runtime using a custom UK date format

4. Modular Architecture
    •    Organized into App, Data, Features, Models, Services, ViewModels, and Views
    •    Easy to extend with new scenarios or categories
    •    JSON format is clean and human-editable
