import SwiftUI

enum TaskCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case work = "Work"
    case learning = "Learning"
    case shopping = "Shopping"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .all:
            "sparkles"
        case .personal:
            "person"
        case .work:
            "briefcase"
        case .learning:
            "book"
        case .shopping:
            "cart"
        }
    }

    var color: Color {
        switch self {
        case .all:
            AppTheme.Palette.blue
        case .personal:
            AppTheme.Palette.pink
        case .work:
            AppTheme.Palette.orange
        case .learning:
            AppTheme.Palette.purple
        case .shopping:
            AppTheme.Palette.green
        }
    }

    // Legacy property for compatibility if needed, but we should use `color`
    var highlightColor: Color { color.opacity(0.2) }
}

struct SidebarView: View {
    @Binding var selection: TaskCategory?

    var body: some View {
        List(selection: $selection) {
            Section("Library") {
                NavigationLink(value: TaskCategory.all) {
                    Label("All Tasks", systemImage: TaskCategory.all.icon)
                        .padding(.vertical, 4)
                }
            }

            Section("Categories") {
                ForEach(TaskCategory.allCases.filter { $0 != .all }) { category in
                    NavigationLink(value: category) {
                        Label {
                            Text(category.rawValue)
                        } icon: {
                            Image(systemName: category.icon)
                                .foregroundColor(category.color)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 200)
    }
}
