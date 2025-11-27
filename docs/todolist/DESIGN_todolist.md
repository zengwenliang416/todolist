# DESIGN_MacToDo

## 1. Architecture Overview
We follow a standard SwiftUI architecture leveraging `@FetchRequest` for data binding and `Core Data` for persistence.

### Components
- **App Entry**: `MacToDoApp` - sets up the Core Data stack and passes `managedObjectContext` to the environment.
- **Persistence**: `PersistenceController` - handles NSPersistentContainer setup.
- **Data Model**:
  - Entity: `TodoItem`
    - `id`: UUID
    - `title`: String
    - `isCompleted`: Boolean
    - `dueDate`: Date?
    - `category`: String (Simple string for categorization to simplify relationship management in this MVP, or distinct Entity. We will use a String property for simplicity in MVP, or an Enum wrapper).
      - *Refinement*: User asked for "Support task classification". A simple String tag or Enum is easiest. Let's use a String property `categoryName`.
- **UI Structure**:
  - `ContentView`: Holds `NavigationView` (or `NavigationSplitView` for macOS).
  - `SidebarView`: List of categories (All, Work, Personal, etc.). Selecting one changes the filter.
  - `TaskListView`: Displays tasks based on the selected category filter.
  - `TaskRowView`: Toggle completion, show title and date.
  - `AddTaskSheet`: Form to create new tasks.

## 2. Data Flow
1. User opens App -> `PersistenceController` loads Store.
2. `ContentView` injects Context.
3. `SidebarView` selects a filter (published state).
4. `TaskListView` uses dynamic `@FetchRequest` (using `nsPredicate`) to show relevant tasks.
5. User actions (add/delete/update) perform `viewContext.save()`.

## 3. File Structure
```
MacToDo/
├── Package.swift
├── Sources/
│   └── MacToDo/
│       ├── MacToDoApp.swift
│       ├── Persistence.swift
│       ├── CoreData/
│       │   └── CoreDataStack.swift (Merged into Persistence.swift)
│       ├── Views/
│       │   ├── ContentView.swift
│       │   ├── SidebarView.swift
│       │   ├── TaskListView.swift
│       │   ├── TaskRowView.swift
│       │   └── AddTaskView.swift
│       └── Resources/
│           ├── MacToDo.xcdatamodeld
│           └── Info.plist
└── scripts/
    └── build_dmg.sh
```

## 4. UI Design (macOS Native)
- **Sidebar**: Translucent material background.
- **List**: Standard Table or List style.
- **Toolbar**: Add button (+), Search bar.
- **Dark Mode**: Standard system colors.
