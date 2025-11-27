import SwiftUI
import CoreData

struct TaskFilteredList: View {
    @FetchRequest var items: FetchedResults<TaskItem>
    var viewModel: TaskListViewModel
    var onAddTask: () -> Void
    
    init(viewModel: TaskListViewModel, onAddTask: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.onAddTask = onAddTask
        
        let request = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        request.sortDescriptors = viewModel.sortDescriptors
        request.predicate = viewModel.predicate
        
        // Use FetchRequest to automatically fetch and update
        _items = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        if items.isEmpty {
            if #available(macOS 14.0, *) {
                ContentUnavailableView {
                    Label("No Tasks", systemImage: "checklist")
                } description: {
                    if viewModel.searchText.isEmpty {
                        Text("You haven't added any tasks yet.")
                    } else {
                        Text("No tasks match your search.")
                    }
                } actions: {
                    if viewModel.searchText.isEmpty {
                        Button("Add Task", action: onAddTask)
                    }
                }
            } else {
                // Fallback for older versions (though we target 14.0)
                VStack(spacing: 20) {
                    Image(systemName: "checklist")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.secondaryText.opacity(0.3))
                    Text("No tasks found")
                        .appFont(size: 20, weight: .medium)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    if viewModel.searchText.isEmpty {
                        Button("Add Task", action: onAddTask)
                            .buttonStyle(.bordered)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            List {
                ForEach(items) { item in
                    TaskRowView(item: item, onToggle: {
                        viewModel.toggleCompletion(item)
                    })
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .contextMenu {
                            Button(role: .destructive) {
                                viewModel.delete(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                viewModel.toggleCompletion(item)
                            } label: {
                                Label(item.isCompleted ? "Mark as Incomplete" : "Mark as Complete", 
                                      systemImage: item.isCompleted ? "circle" : "checkmark")
                            }
                        }
                }
            }
            .listStyle(.plain)
        }
    }
}
