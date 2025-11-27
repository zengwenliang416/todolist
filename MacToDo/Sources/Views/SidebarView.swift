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
        case .personal: return "heart" // Using outline versions for sketch feel
        case .work: return "briefcase"
        case .learning: return "book"
        case .shopping: return "bag"
        }
    }
    
    var highlightColor: Color {
        switch self {
        case .all: return SketchTheme.highlighterBlue
        case .personal: return SketchTheme.highlighterPink
        case .work: return SketchTheme.highlighterYellow
        case .learning: return SketchTheme.highlighterBlue
        case .shopping: return SketchTheme.highlighterYellow
        }
    }
}

struct SidebarView: View {
    @Binding var selection: TaskCategory?
    
    var body: some View {
        ZStack {
            // Glass Background for Sidebar
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            Color.white.opacity(0.1).ignoresSafeArea()
            
            // Margin Line (Etched style)
            HStack {
                Rectangle()
                    .fill(SketchTheme.marginPink.opacity(0.6))
                    .frame(width: 2)
                    .padding(.leading, 30)
                    .blur(radius: 0.5)
                Spacer()
            }
            
            List(selection: $selection) {
                Section(header: Text("NOTEBOOK").sketchFont(size: 14, weight: .bold)) {
                    NavigationLink(destination: TaskListView(category: .all), tag: TaskCategory.all, selection: $selection) {
                        CategoryRow(category: .all, isSelected: selection == .all)
                    }
                }
                
                Section(header: Text("SECTIONS").sketchFont(size: 14, weight: .bold)) {
                    ForEach(TaskCategory.allCases.filter { $0 != .all }) { category in
                        NavigationLink(destination: TaskListView(category: category), tag: category, selection: $selection) {
                            CategoryRow(category: category, isSelected: selection == category)
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())
        }
        .frame(minWidth: 200)
    }
}

struct CategoryRow: View {
    let category: TaskCategory
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .font(.system(size: 16, weight: .light)) // Light weight for "pencil" stroke look
                .foregroundColor(SketchTheme.pencilGraphite)
                .frame(width: 20)
            
            Text(category.rawValue)
                .sketchFont(size: 18, weight: .regular)
                .foregroundColor(SketchTheme.pencilGraphite)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(
            isSelected ? 
            RoundedRectangle(cornerRadius: 4)
                .fill(category.highlightColor)
                .rotationEffect(.degrees(-1)) // Slightly crooked highlight
            : nil
        )
    }
}
