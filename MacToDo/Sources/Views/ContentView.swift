import SwiftUI

struct ContentView: View {
    @State private var selection: TaskCategory? = .all
    
    var body: some View {
        NavigationView {
            SidebarView(selection: $selection)
            
            // Default View (Initial Detail)
            TaskListView(category: .all)
        }
        .frame(minWidth: 700, minHeight: 400)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
