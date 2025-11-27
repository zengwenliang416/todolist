# Final Report: MacToDo (Sketch Edition)

## Project Overview
MacToDo is a macOS-native To-Do application built with SwiftUI and Core Data. It features a unique "Hand-drawn" (Sketch) theme that mimics a notebook, complete with pencil-drawn borders, handwritten fonts, and highlighter accents. It also includes a "Smart Sort" feature mocking future macOS 26 intelligence.

## Delivered Features
1.  **Task Management**: Create, Read, Update, Delete (CRUD) tasks.
2.  **Categorization**: Organize tasks by categories (Personal, Work, Shopping, etc.) with sidebar navigation.
3.  **Reminders**: Set due dates and receive local notifications.
4.  **Hand-drawn + Glass UI**:
    -   **Notebook Style**: Lined paper backgrounds, margin lines.
    -   **Sketchy Elements**: Wobbly borders, pencil-shaded checkboxes, handwritten typography (Chalkboard SE).
    -   **Glassmorphism (iOS 26 Style)**: Frosted glass textures (`.ultraThinMaterial`) blended with sketch elements (`GlassySketch` style).
    -   **Highlighter Accents**: Randomly rotated highlighter marks for selected items.
5.  **Smart Features**: "Smart Sort" button that mocks AI optimization with a toast notification.
6.  **Persistence**: Data saved locally using Core Data (programmatic stack).
7.  **Packaging**: Automated script (`scripts/build_app.sh`) to build `.app` and `.dmg`.
8.  **Logo**: Custom generated "Glassy Sketch" App Icon (`AppIcon.icns`).

## Technical Architecture
-   **Framework**: SwiftUI (macOS 12+)
-   **Data Model**: Core Data (`TaskItem` entity)
-   **Theme Engine**: `Theme.swift` with `SketchTheme` struct providing centralized colors, fonts, and modifiers.
-   **Build System**: Swift Package Manager + Shell Scripting for bundling.
-   **Asset Generation**: Python script (`scripts/generate_logo.py`) using Pillow to generate procedural icons.

## File Structure
-   `Sources/App.swift`: App entry point.
-   `Sources/Model/`: Core Data stack and entities.
-   `Sources/Views/`:
    -   `Theme.swift`: Definition of the Sketch theme.
    -   `SidebarView.swift`: Notebook-style sidebar.
    -   `TaskListView.swift`: Lined paper list view.
    -   `TaskRowView.swift`: Sketchy task item row.
    -   `AddTaskView.swift`: "New Scribble" dialog.

## Instructions
1.  **Run**: Open `MacToDo.app` in the project root.
2.  **Install**: Open `MacToDo.dmg` and drag to Applications.
3.  **Build from Source**: Run `./scripts/build_app.sh`.

## Conclusion
The project meets all functional requirements (CRUD, Categories, Persistence) and satisfies the aesthetic requirements (Hand-drawn style) and future-proofing request (macOS 26 mock).
