# TASK_MacToDo

## Phase 1: Foundation
- [ ] **Task 1.1**: Initialize Swift Package.
  - Run `swift package init --type executable`.
  - Configure `Package.swift` for macOS 12.0 platform.
- [ ] **Task 1.2**: Create App Entry & Info.plist.
  - Create `Sources/MacToDo/MacToDoApp.swift`.
  - Create `Sources/MacToDo/Resources/Info.plist`.

## Phase 2: Data Layer
- [ ] **Task 2.1**: Implement Persistence Controller.
  - Create `Sources/MacToDo/Persistence.swift`.
  - **Crucial**: Implement `NSManagedObjectModel` programmatically to avoid `.xcdatamodeld` compilation issues.
  - Define `TodoItem` entity properties in code.
- [ ] **Task 2.2**: Create Core Data Helper Extensions.
  - Helper to access the shared context.
  - Helper for preview data.

## Phase 3: UI Implementation
- [ ] **Task 3.1**: Sidebar and Navigation.
  - `SidebarView.swift`: Category selection logic.
- [ ] **Task 3.2**: Task List & Row.
  - `TaskListView.swift`: FetchRequest with dynamic predicate.
  - `TaskRowView.swift`: Display task and completion toggle.
- [ ] **Task 3.3**: Task Creation & Editing.
  - `AddTaskView.swift`: Form for new tasks.
  - Date picker integration.

## Phase 4: Integration & Build
- [ ] **Task 4.1**: Notifications.
  - Request permission on app launch.
  - Schedule local notification when task is created with due date.
- [ ] **Task 4.2**: Build Script.
  - `scripts/build_app.sh`.
  - Compile using `swift build`.
  - Create `.app` bundle structure (`Contents/MacOS`, `Contents/Resources`).
  - Copy `Info.plist` and binary.
  - Sign (ad-hoc) if necessary.
- [ ] **Task 4.3**: DMG Packaging.
  - Add `hdiutil` commands to the script to generate `.dmg`.

## Phase 5: Verification
- [ ] **Task 5.1**: Run Validation.
  - Verify app launches.
  - Verify data persists after restart.
