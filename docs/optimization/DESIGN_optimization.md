# DESIGN_Optimization

## 1. Architecture Overview
We will adopt a **MVVM + Repository** pattern to separate concerns, while retaining SwiftUI's native Core Data integration for performance.

```mermaid
graph TD
    View[TaskListView] -->|Observes| VM[TaskListViewModel]
    View -->|Binds| FR[@FetchRequest]
    VM -->|Calls| Repo[TaskRepository]
    VM -->|Provides| Config[SortDescriptors/Predicates]
    Repo -->|Operates| CD[Core Data Context]
```

## 2. Components

### 2.1 TaskRepository (Service Layer)
- **Responsibility**: Handle all Create/Update/Delete (CUD) operations.
- **Interface**:
  - `func addTask(title: String, category: TaskCategory)`
  - `func deleteTask(_ item: TaskItem)`
  - `func toggleCompletion(_ item: TaskItem)`
- **Concurrency**: Uses `performBackgroundTask` or actor isolation to ensure thread safety.

### 2.2 TaskListViewModel (Presentation Layer)
- **Responsibility**: 
  - Manage UI state (`showAddTask`, `sortOption`, `selectedCategory`).
  - Provide `NSPredicate` and `[NSSortDescriptor]` to the View's FetchRequest.
  - Forward user actions to `TaskRepository`.
- **State**:
  - `var sortOption: SortOption`
  - `var searchText: String`

### 2.3 TaskListView (View Layer)
- **Responsibility**: Render the UI.
- **Optimization**:
  - Replace `LazyVStack` with `List`.
  - Remove `displayItems` computed property.
  - Use `DynamicFetchView` (a helper view) or `.onChange` to update the FetchRequest, OR inject the configuration.
  - *Best Practice*: Create a subview `TaskFilteredList` that takes the predicate/sort descriptors in `init`. This forces a refresh when they change.

## 3. Data Flow
1.  User changes Sort Option in ViewModel.
2.  ViewModel updates `sortDescriptors` property.
3.  View passes new descriptors to `TaskFilteredList`.
4.  `TaskFilteredList` recreates `@FetchRequest` (implicitly via `init`) and fetches data efficiently from SQLite.
5.  Core Data returns results.
6.  List updates.

## 4. Directory Structure
```
Sources/
  Services/
    TaskRepository.swift
  ViewModels/
    TaskListViewModel.swift
  Views/
    Components/
      TaskFilteredList.swift
```
