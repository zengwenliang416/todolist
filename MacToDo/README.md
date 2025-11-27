# MacToDo

A native macOS To-Do application built with SwiftUI and Core Data.

## Features
- Task Management (Add, Edit, Delete, Complete)
- Categorization (Work, Personal, Learning, etc.)
- Due Dates & Local Notifications
- Dark Mode Support
- Data Persistence (Core Data)

## Installation
1. Download the `MacToDo.dmg`.
2. Open it and drag the app to Applications.

## Building from Source
Prerequisites: macOS 12+, Xcode Command Line Tools.

1. Clone the repository.
2. Run the build script:
   ```bash
   ./scripts/build_app.sh
   ```
3. The output DMG will be in the project root.

## Usage
- **Add Task**: Use the + button.
- **Filter**: Select categories in the sidebar.
- **Complete**: Click the circle checkbox.
