import CoreData
import SwiftUI

struct TaskListView: View {
    @State private var viewModel: TaskListViewModel
    @State private var showAddTask = false

    init(category: TaskCategory) {
        _viewModel = State(initialValue: TaskListViewModel(category: category))
    }

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header & Controls
                VStack(spacing: 12) {
                    HStack {
                        Text(viewModel.selectedCategory.rawValue)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.primaryText)
                        Spacer()

                        Menu {
                            Picker("Sort", selection: $viewModel.sortOption) {
                                Text("Default").tag(SortOption.default)
                                Text("Due Date").tag(SortOption.dueDateAsc)
                                Text("Created").tag(SortOption.createdDesc)
                            }
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                        }
                        .menuStyle(.borderlessButton)
                    }

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search tasks...", text: $viewModel.searchText)
                            .textFieldStyle(.plain)
                            .font(.body)
                    }
                    .padding(10)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 10)

                // List
                TaskFilteredList(viewModel: viewModel) {
                    showAddTask = true
                }
            }
            .padding(.bottom, 0)

            // Floating Add Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showAddTask = true }) {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(AppTheme.accent)
                            .clipShape(Circle())
                            .shadow(radius: 4, y: 2)
                    }
                    .padding(24)
                    .buttonStyle(.plain)
                }
            }
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView(defaultCategory: viewModel.selectedCategory, repository: viewModel.repository)
        }
    }
}
