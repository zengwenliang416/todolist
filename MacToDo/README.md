# MacToDo

[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-FA7343.svg)](https://swift.org)
[![Platform macOS](https://img.shields.io/badge/platform-macOS%2014%2B-black.svg)](https://developer.apple.com/macos/)
[![Build With SwiftPM](https://img.shields.io/badge/build-SwiftPM-informational.svg)](https://www.swift.org/package-manager/)

> Native macOS to-do manager that blends a hand-drawn "notebook" aesthetic with Core Data persistence, smart sorting, and automated packaging.

![MacToDo logo](../docs/logo.png)

## Table of Contents
- [Overview](#overview)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Building & Packaging](#building--packaging)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [Automation & Scripts](#automation--scripts)
- [Documentation](#documentation)
- [Troubleshooting](#troubleshooting)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

## Overview
MacToDo is built entirely with SwiftUI and Core Data for macOS. It embraces a "glassy sketch" visual system inspired by notebook pages, pencil strokes, and highlighter accents while staying fully accessible and keyboard friendly. A lightweight Core Data stack keeps all tasks local and private, and a release script outputs both an `.app` bundle and signed `.dmg` installer.

## Key Features
- **Task lifecycle** — Add, edit, complete, and delete tasks with inline interactions.
- **Category sidebar** — Predefined categories (Work, Personal, Learning, Shopping, etc.) plus an "All" catch-all filter.
- **Due dates & reminders** — Optional notification scheduling backed by the local notification center.
- **Smart Sort** — One-click mock automation that previews how future macOS intelligence might reprioritize tasks.
- **Sketch + glass theme** — Randomized wobbly borders, lined-paper backgrounds, Chalkboard SE typography, and frosted glass accents defined in `Theme.swift`.
- **Persistence** — `TaskItem` Core Data entity and `PersistenceController` keep data on-device with undo/redo support.
- **Packaging** — `scripts/build_app.sh` handles compiling, icon generation, ad-hoc signing, and DMG creation.

## Architecture
- **Presentation**: SwiftUI views (`ContentView`, `SidebarView`, `TaskListView`, `TaskRowView`, `AddTaskView`) provide the sketch-themed UI.
- **State management**: `TaskListViewModel` orchestrates filtering, mutation, and derived state for the UI.
- **Domain layer**: `TaskItem` model plus helper types under `Sources/Model` cover sorting and Core Data representations.
- **Data access**: `TaskRepository` abstracts CRUD logic on top of the Core Data stack defined in `Persistence.swift`.
- **Services**: Local notifications and smart sort toasts live inside the view-model/service layer, keeping views declarative.

## Requirements
- macOS 14.0 or later (tested with Sonoma)
- Xcode Command Line Tools or full Xcode 15+
- Swift 5.9 toolchain (Swift Package Manager is used for builds/tests)
- Python 3.9+ with Pillow (`pip install pillow`) if you want to regenerate the procedural icon
- `iconutil`, `codesign`, and `hdiutil` are expected when running the packaging script

## Quick Start
### Option 1: Install the packaged app
1. Download or build the latest `MacToDo.dmg` in the repo root.
2. Open the DMG and drag **MacToDo** into `/Applications`.
3. Launch the app and grant notification permission the first time it prompts you.

### Option 2: Run from source
```bash
# clone the repository
$ git clone https://github.com/<your-account>/todolist.git
$ cd todolist/MacToDo

# build & run with SwiftPM
$ swift run
```
Alternatively open `MacToDo/Package.swift` in Xcode and press **Run**.

## Building & Packaging
`./scripts/build_app.sh` is the single entry point for release builds:
1. Generates or refreshes the sketch-style icon via `scripts/generate_logo.py` (optional, requires Pillow).
2. Converts the iconset to `AppIcon.icns` with `iconutil`.
3. Builds the executable with `swift build -c release`.
4. Creates a macOS `.app` bundle with the packaged binary and Info.plist.
5. Applies ad-hoc `codesign` and assembles `MacToDo.dmg` via `hdiutil`.

Outputs:
- `MacToDo.app` in the project root
- `MacToDo.dmg` alongside the app bundle

## Testing
Unit tests live under `Tests/MacToDoTests` and cover sorting rules, persistence, and the task list view model:
```bash
$ swift test
```
Add new tests whenever you change business rules, particularly around sorting or repository behavior.

## Project Structure
```
MacToDo/
├── Package.swift            # Swift Package definition
├── Resources/               # Generated icons and bundle assets
├── Sources/
│   ├── MacToDoApp.swift     # App entry point
│   ├── Persistence.swift    # Core Data stack
│   ├── Model/               # TaskItem entity + sorting helpers
│   ├── ViewModels/          # TaskListViewModel
│   ├── Views/               # SwiftUI screens + Theme definitions
│   └── Services/            # TaskRepository and related helpers
├── Tests/MacToDoTests/      # Unit tests (sorting, persistence, view-model)
├── scripts/                 # build_app.sh, generate_logo.py
└── docs/                    # User manual and supporting documents
```

## Automation & Scripts
| Script | Description |
| --- | --- |
| `scripts/build_app.sh` | Full release pipeline: compile, bundle, sign, and create DMG. |
| `scripts/generate_logo.py` | Procedurally draws the glassy-sketch icon and exports all iconset sizes via Pillow. |

## Documentation
- [User Manual](docs/todolist/USER_MANUAL.md) – day-to-day usage guide.
- [Design + Acceptance Docs](docs/todolist) – requirements, alignment notes, and final report for the sketch-themed experience.

## Troubleshooting
- **Notifications not showing**: Re-enable alerts under `System Settings → Notifications → MacToDo`.
- **`iconutil` or `codesign` missing**: Install Xcode Command Line Tools (`xcode-select --install`).
- **Permission prompts**: macOS may flag unsigned apps; right-click the app and select **Open** the first time.

## Roadmap
- Implement full-text search across tasks.
- Extend Smart Sort with real heuristics (due date proximity, completion state).
- Explore iCloud sync while keeping Core Data local-first.

## Contributing
1. Fork and branch from `main`.
2. Run `swift test` and, if applicable, `./scripts/build_app.sh` before submitting a PR.
3. Document UI changes with updated screenshots in `docs/`.

## License
A license file has not been added yet. Please include one (MIT/Apache-2.0/etc.) before distributing the app publicly.
