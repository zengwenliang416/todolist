# ALIGNMENT_MacToDo

## 1. Project Context
- **Goal**: Develop a native macOS To-Do application.
- **Target OS**: macOS 12.0 Monterey and later.
- **Tech Stack**: Swift, SwiftUI, Core Data.
- **Delivery**: Source code + DMG installer.

## 2. Requirements Analysis
### Functional
- **CRUD**: Create, Read, Update, Delete tasks.
- **Categorization**: Sidebar with categories (Work, Personal, Learning, etc.).
- **Reminders**: Date/Time picker, Local Notifications.
- **Persistence**: Core Data.

### UI/UX
- **Style**: macOS Native (HIG compliant).
- **Layout**: NavigationSplitView (Sidebar + Detail) or HSplitView.
- **Theme**: Support Dark/Light mode automatically.

### Technical
- **Framework**: SwiftUI (App protocol).
- **Build System**: Swift Package Manager (with custom script to bundle as .app).
- **Packaging**: `hdiutil` for DMG.

## 3. Key Decisions & Assumptions
- **Project Structure**: We will use a Swift Package Manager executable structure, but wrapping it into a `.app` bundle structure manually via a build script to ensure it runs as a proper macOS GUI app with resources (Icon, Info.plist). This avoids the complexity of generating `project.pbxproj` files.
- **Data Model**:
  - `ToDoItem`: id, title, isCompleted, dueDate, createdAt, category (relationship).
  - `Category`: id, name, color, icon.
- **Notifications**: Will request permission on first launch or first reminder setting.

## 4. Unresolved / Clarification
- None. Proceeding with standard best practices.
