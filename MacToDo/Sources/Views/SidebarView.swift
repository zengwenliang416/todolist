import SwiftUI

enum TaskCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case work = "Work"
    case learning = "Learning"
    case shopping = "Shopping"
    
    var id: String { self.rawValue }
    var icon: String {
        switch self {
        case .all: return "sparkles"
        case .personal: return "person"
        case .work: return "briefcase"
        case .learning: return "book"
        case .shopping: return "cart"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return AppTheme.Palette.blue
        case .personal: return AppTheme.Palette.pink
        case .work: return AppTheme.Palette.orange
        case .learning: return AppTheme.Palette.purple
        case .shopping: return AppTheme.Palette.green
        }
    }
    
    // Legacy property for compatibility if needed, but we should use `color`
    var highlightColor: Color {
        return color.opacity(0.2)
    }
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
