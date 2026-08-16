# Financial Health Check

An iOS client for a server-driven financial health-check questionnaire. The backend already
exists — this project is the native app that walks a user through a short, dynamic
questionnaire and shows their resulting financial health score.

## Overview

The flow has three stages, each driven entirely by the API's response rather than any
client-side script:

1. **Start** — an intro screen with a "Start" button, which begins (or resumes) a session.
2. **Question** — one question at a time (`single_choice`, `multiple_choice`, or `number`),
   submitted one at a time; the server's response to each submission is either the next
   question or the final result.
3. **Result** — the session's score and category (`poor`/`fair`/`good`/`excellent`), with the
   option to retake the questionnaire.

The app persists the in-progress session's id locally (Keychain), so relaunching mid-flow
resumes exactly where the user left off instead of restarting.

## Design Resources

- **[Figma — Design System](https://www.figma.com/design/ztqxSwQ9AkH2HKyADYnw68/iOS-Assignment-Design-System-v3?node-id=0-1&p=f&t=HdinADG2WpTggoVH-0)**
  — the source of truth for every design-system component (`designSystem/`), colors,
  typography, and spacing.
- **[Paper — Navigation Flow](https://app.paper.design/file/01KZVRH6WWBZJBSHJXMCNH8ZPJ/1-0)**
  — the app's screen-to-screen navigation flow, mirrored by the Coordinator tree.
- **[Miro — Data Modeling](https://miro.com/app/board/uXjVHynVQDI=/)**
  — the modeling behind the `model/` DTOs and the API's request/response shapes.

<!-- Screenshots to be added here. -->

## Architecture

The app follows **MVVM-C** (Model, View, ViewModel, Coordinator):

- **Model** — plain `Codable` DTOs (`model/`), all-optional fields since every shape is
  server-driven.
- **View** — SwiftUI screens (`View/`), built from reusable `designSystem/` components.
- **ViewModel** — one `ObservableObject` per screen (`ViewModel/`), holding that screen's state
  and calling into `HealthCheckRepository` for data.
- **Coordinator** — one per flow (`coordinators/`), owning navigation and wiring each
  ViewModel's callbacks to "what happens next."

Dependency injection is plain constructor injection, no framework: `AppCoordinator` creates a
single `HealthCheckRepository` and threads it down through every child Coordinator's
initializer, which in turn passes it into the ViewModel it creates.

## Project Structure

```
Financial-Health-Check/
├── README.md                  This file.
└── financialHealthCheck/
    └── financialHealthCheck/
        ├── AppDelegate.swift
        ├── SceneDelegate.swift          Creates and starts `AppCoordinator`.
        ├── Strings.swift                Every user-facing string, grouped by screen.
        ├── String+Empty.swift           `Optional<String>.isNilOrEmpty`.
        │
        ├── model/                       Codable DTOs — the API's request/response shapes.
        │   ├── DTO.swift                 Marker protocol every model conforms to.
        │   ├── HealthCheckSessionDTO.swift   Shared response shape for both endpoints.
        │   ├── QuestionDTO.swift
        │   ├── QuestionOptionDTO.swift
        │   ├── QuestionType.swift        `single_choice` / `multiple_choice` / `number`.
        │   ├── QuestionValidationDTO.swift
        │   ├── ProgressDTO.swift
        │   ├── ResultDTO.swift
        │   ├── ResultCategory.swift      `poor` / `fair` / `good` / `excellent`.
        │   ├── AnswerValue.swift         Custom-encoded answer (string, array, or number).
        │   ├── SubmitAnswerRequestDTO.swift
        │   └── APIErrorDTO.swift         Decoded from non-2xx responses.
        │
        ├── services/                    Generic infrastructure — no domain knowledge.
        │   ├── NetworkManager.swift      Generic HTTP transport (encode/decode/validate).
        │   ├── Endpoint.swift            URL base + path segments.
        │   ├── NetworkError.swift        Typed errors, mapped from the API's error codes.
        │   └── KeychainManager.swift     Persists the session id; the only Keychain access.
        │
        ├── repositories/                Domain operations — the only thing ViewModels use.
        │   └── HealthCheckRepository.swift   `startSession()`, `submitAnswer(_:)`, etc.
        │
        ├── coordinators/                Navigation — one per flow.
        │   ├── Coordinator.swift         Base protocol (`func start()`).
        │   ├── AppCoordinator.swift       Root — resolves session state, routes to a flow.
        │   ├── StartCoordinator.swift
        │   ├── QuestionCoordinator.swift  Pushes one question at a time.
        │   └── ResultCoordinator.swift
        │
        ├── ViewModel/                   One `ObservableObject` per screen.
        │   ├── StartViewModel.swift
        │   ├── QuestionaryViewModel.swift
        │   └── ResultViewModel.swift
        │
        ├── View/                        SwiftUI screens.
        │   ├── StartView.swift
        │   ├── QuestionaryView.swift
        │   └── ResultView.swift
        │
        └── designSystem/                Reusable, screen-agnostic UI building blocks.
            ├── colorPalette/             `Palette`, `DesignSystemColor`, `Color+Hex`.
            ├── typographyScale/          `Typography`, `TypographyToken`, UIKit/SwiftUI bridges.
            ├── spacingScale/             `Spacing`.
            ├── icons/                    `Icon`.
            ├── buttons/                  `AppButton`, `ButtonDock`, styling/metrics.
            ├── textFields/               `AppTextField`.
            ├── selectControls/           `AppSelectControl`.
            ├── radioButtons/             `RadioButtonListItem` (single choice).
            ├── checkboxes/               `CheckboxListItem` (multiple choice).
            ├── listItems/                `ListItem` — shared base for the two above.
            ├── header/                   `ScreenHeader`, `ImageHeader`.
            ├── scoreDisplay/             `ScoreDisplay` — the circular score ring.
            └── navigation/               `NavigationHeader`, `NavigationProgressBarView`,
                                           `NavigationHostingController` — the UIKit/SwiftUI
                                           hosting boundary for the custom nav bar.
```

## App Flow

```
AppCoordinator (splash) — resolves where to land based on the persisted session, if any
 ├─ no session            → StartCoordinator     (intro screen, "Start" begins a session)
 ├─ session in progress   → QuestionCoordinator  (resumes on the current question)
 └─ session completed     → ResultCoordinator    (shows the existing result)

StartCoordinator
 └─ "Start" tapped → starts a session → QuestionCoordinator

QuestionCoordinator
 ├─ "Continue" tapped, more questions left → pushes the next QuestionCoordinator
 └─ "Continue" tapped, that was the last question → ResultCoordinator

ResultCoordinator
 ├─ "Retake" tapped → deletes the session → StartCoordinator
 └─ "Finish" tapped → open
```

## Networking

Two endpoints, both returning the same `HealthCheckSessionDTO` shape (either the next question
or the final result):

- `POST /health-check/v1/sessions/{sessionId}` — start or resume a session.
- `POST /health-check/v1/sessions/{sessionId}/submission` — submit the current question's
  answer; the response already contains what comes next.

## Credits

- [SwiftUI: Create a Custom Progress Bar](https://medium.com/@simply_stef/swiftui-create-a-custom-progress-bar-8d119aa78d45) by Stef — reference for the `ScoreDisplay` circular progress component.
