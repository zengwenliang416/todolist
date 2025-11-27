import SwiftUI
import Observation
import CoreData

@Observable
@MainActor
class TaskListViewModel {
    var sortOption: SortOption = .default
    var searchText: String = ""
    var selectedCategory: TaskCategory
    
    @ObservationIgnored
    let repository: TaskRepository
    
    init(category: TaskCategory, repository: TaskRepository = TaskRepository()) {
        self.selectedCategory = category
        self.repository = repository
    }
    
    var sortDescriptors: [NSSortDescriptor] {
        switch sortOption {
        case .default:
            return [
                NSSortDescriptor(keyPath: \TaskItem.isCompleted, ascending: true),
                NSSortDescriptor(keyPath: \TaskItem.createdAt, ascending: false),
                NSSortDescriptor(keyPath: \TaskItem.title, ascending: true)
            ]
        case .dueDateAsc:
            return [
                NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true),
                NSSortDescriptor(keyPath: \TaskItem.title, ascending: true)
            ]
        case .createdDesc:
            return [
                NSSortDescriptor(keyPath: \TaskItem.createdAt, ascending: false),
                NSSortDescriptor(keyPath: \TaskItem.title, ascending: true)
            ]
        }
    }
    
    var predicate: NSPredicate? {
        var predicates: [NSPredicate] = []
        
        // Category Filter
        if selectedCategory != .all {
            predicates.append(NSPredicate(format: "category == %@", selectedCategory.rawValue))
        }
        
        // Search Filter
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }
        
        if predicates.isEmpty {
            return nil
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
    // MARK: - Actions
    
    func addTask(title: String, date: Date?) {
        repository.addTask(title: title, category: selectedCategory, date: date)
    }
    
    func delete(_ item: TaskItem) {
        repository.delete(item)
    }
    
    func toggleCompletion(_ item: TaskItem) {
        repository.toggleCompletion(item)
    }
}
