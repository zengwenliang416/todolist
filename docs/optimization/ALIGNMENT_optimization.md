# ALIGNMENT_Optimization

## 1. Project Context
- **Project**: MacToDo (macOS App)
- **Current State**: Functional basic Todo app using SwiftUI and Core Data.
- **Goal**: Optimize architecture, performance, and code quality. Add missing critical features if any.

## 2. Identified Issues & Opportunities

### Architecture (Priority: High)
- **Problem**: Logic is tightly coupled with Views (`TaskListView` handles sorting, deletion, and context fetching directly).
- **Solution**: Adopt **MVVM** pattern.
  - Introduce `TaskListViewModel` using Swift 5.9 `@Observable` macro.
  - Introduce `TaskRepository` (Service Layer) to encapsulate Core Data logic.

### Performance (Priority: High)
- **Problem**: `TaskListView` converts `FetchedResults` to `Array` and sorts them in-memory on every view update (`var displayItems`). This negates Core Data's lazy loading benefits and is O(N log N) on the main thread.
- **Solution**: 
  - Push sorting to the database level using `NSSortDescriptor` in `NSFetchRequest`.
  - Use `SectionedFetchRequest` if grouping is needed.

### Concurrency (Priority: Medium)
- **Problem**: Database operations (delete, fetch) happen on the `viewContext` (Main Queue). While acceptable for small datasets, it risks UI hangs.
- **Solution**: 
  - Ensure `TaskRepository` uses `perform` or `performBackgroundTask` for writes.
  - Use Swift Concurrency (`async/await`) for the repository interface.

### UI/UX (Priority: Medium)
- **Problem**: `LazyVStack` in `ScrollView` is used. On macOS, `List` offers better keyboard navigation, selection support, and performance.
- **Solution**: Refactor `TaskListView` to use `List`.

### New Features (Suggested)
- **Search**: Currently no way to find tasks.
- **Empty State**: Improve empty state visuals.

## 3. Execution Plan (Proposed)
1.  **Refactor**: Create `TaskRepository` and `TaskViewModel`.
2.  **Optimize**: Update `TaskListView` to use ViewModel and efficient fetching.
3.  **Feature**: Add Search functionality.

## 4. Questions for User
1.  Do you agree with the MVVM + Repository refactoring?
2.  Should we switch from `LazyVStack` to standard macOS `List`?
3.  Is "Search" a desired new feature?
