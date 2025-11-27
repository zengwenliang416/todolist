# TASK_Optimization

## 1. Foundation Layer
- [ ] **Create TaskRepository**
  - Define `TaskRepository` class/actor.
  - Implement `addItem`, `deleteItem`, `updateItem`.
  - Ensure operations use `viewContext` safely (or background context if we want to be fancy, but for now viewContext is simpler for binding). *Correction*: Best practice is `viewContext` for UI-driving data, background for imports. We'll stick to `viewContext` for simplicity but wrap it nicely.

## 2. ViewModel Layer
- [ ] **Create TaskListViewModel**
  - Implement `@Observable` class.
  - Properties: `sortOption`, `searchText`, `selectedCategory`.
  - Computed: `sortDescriptors`, `predicate`.

## 3. View Layer
- [ ] **Create TaskFilteredList Component**
  - A view that accepts `predicate` and `sortDescriptors`.
  - Contains the `@FetchRequest`.
  - Renders the `List`.
- [ ] **Update TaskListView**
  - Integrate `TaskListViewModel`.
  - Use `TaskFilteredList`.
  - Add Search Bar (`.searchable`).

## 4. Cleanup
- [ ] Remove legacy sorting code from `TaskListView`.
- [ ] Verify functionality.
