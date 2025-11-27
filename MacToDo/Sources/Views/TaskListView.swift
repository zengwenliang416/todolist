import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var items: FetchedResults<TaskItem>
    
    @State private var showAddTask = false
    @State private var showSmartToast = false
    @State private var sortOption: SortOption = .default
    let category: TaskCategory
    
    init(category: TaskCategory) {
        self.category = category
        let request = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskItem.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TaskItem.createdAt, ascending: false)
        ]
        
        if category != .all {
            request.predicate = NSPredicate(format: "category == %@", category.rawValue)
        }
        
        _items = FetchRequest(fetchRequest: request)
    }
    
    var displayItems: [TaskItem] {
        sortTasks(Array(items), by: sortOption)
    }
    
    var body: some View {
        ZStack {
            // Glass Background (Desktop/Window blur)
            Rectangle().fill(.regularMaterial).ignoresSafeArea()
            Color.white.opacity(0.05).ignoresSafeArea()
            
            // Etched Glass Lines
            GeometryReader { geometry in
                Path { path in
                    let lineSpacing: CGFloat = 32
                    for y in stride(from: 40, through: geometry.size.height, by: lineSpacing) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                }
                .stroke(Color.white.opacity(0.2), lineWidth: 1) // Etched look
            }
            .ignoresSafeArea()
            
            if items.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 60))
                        .foregroundColor(SketchTheme.pencilGray.opacity(0.5))
                    Text("Empty Glass...")
                        .sketchFont(size: 24, weight: .bold)
                        .foregroundColor(SketchTheme.pencilGray)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Title Header
                        HStack {
                            Text(category.rawValue)
                                .sketchFont(size: 32, weight: .bold)
                                .foregroundColor(SketchTheme.pencilGraphite)
                                .shadow(color: .white, radius: 2, x: 0, y: 1) // Glass text depth
                                .padding(.horizontal, 12)
                                .background(
                                    SketchTheme.highlighterYellow
                                        .mask(Rectangle().padding(.vertical, 10))
                                        .rotationEffect(.degrees(-1))
                                        .opacity(0.7)
                                )
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        ForEach(displayItems) { item in
                            TaskRowView(item: item)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteItem(item)
                                    } label: {
                                        Label("Erase", systemImage: "eraser")
                                    }
                                }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            
            // Smart Toast (Glass)
            if showSmartToast {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(.white)
                        Text(smartToastText)
                            .sketchFont(size: 14)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0.1)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
                    )
                    .shadow(radius: 10)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .zIndex(100)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack {
                    // macOS 26 Smart Feature Mock
                    Button(action: {
                        withAnimation {
                            cycleSortOption()
                            showSmartToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSmartToast = false
                            }
                        }
                    }) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14))
                        Text(currentSortLabel)
                            .sketchFont(size: 12)
                    }
                    .help("Sorts tasks using macOS 26 AI (Mock)")
                    
                    Button(action: { showAddTask = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                }
            }
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView(defaultCategory: category == .all ? .personal : category)
        }
    }
    
    private func deleteItem(_ item: TaskItem) {
        withAnimation {
            viewContext.delete(item)
            try? viewContext.save()
        }
    }
    
    private var currentSortLabel: String {
        switch sortOption {
        case .default: return "Smart Sort"
        case .dueDateAsc: return "Due Date"
        case .createdDesc: return "Recent"
        }
    }
    
    private var smartToastText: String {
        switch sortOption {
        case .default: return "Sorted: Smart"
        case .dueDateAsc: return "Sorted: Due Date ↑"
        case .createdDesc: return "Sorted: Created ↓"
        }
    }
    
    private func cycleSortOption() {
        let all = SortOption.allCases
        if let idx = all.firstIndex(of: sortOption) {
            sortOption = all[(idx + 1) % all.count]
        } else {
            sortOption = .default
        }
    }
}
