import SwiftUI

struct ContentView: View {
    @State private var selection: TaskCategory? = .all
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selection: $selection)
                .navigationTitle("MacToDo")
        } detail: {
            if let category = selection {
                TaskListView(category: category)
                    .id(category) // Ensure ViewModel is recreated when category changes
            } else {
                Text("Select a category")
                    .foregroundColor(.secondary)
            }
        }
        .frame(minWidth: 700, minHeight: 400)
    }
}
