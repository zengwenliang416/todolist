import Testing
import Foundation
import CoreData
@testable import MacToDo

@MainActor
struct ViewModelTests {
    let persistence: PersistenceController
    let repository: TaskRepository
    let viewModel: TaskListViewModel
    
    init() {
        persistence = PersistenceController(inMemory: true)
        repository = TaskRepository(context: persistence.container.viewContext)
        viewModel = TaskListViewModel(category: .all, repository: repository)
    }
    
    @Test("Add Task")
    func testAddTask() async throws {
        viewModel.addTask(title: "New Task", date: nil)
        
        let fetchRequest = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        let items = try persistence.container.viewContext.fetch(fetchRequest)
        
        #expect(items.count == 1)
        #expect(items.first?.title == "New Task")
        #expect(items.first?.category == "All")
    }
    
    @Test("Filter Predicate")
    func testPredicate() {
        // Search text
        viewModel.searchText = "Hello"
        let p1 = viewModel.predicate
        #expect(p1 != nil)
        #expect(p1?.predicateFormat.contains("title CONTAINS[cd] \"Hello\"") == true)
        
        // Category
        let vm2 = TaskListViewModel(category: .work, repository: repository)
        let p2 = vm2.predicate
        #expect(p2?.predicateFormat.contains("category == \"Work\"") == true)
    }
    
    @Test("Sort Descriptors")
    func testSort() {
        viewModel.sortOption = .dueDateAsc
        let descriptors = viewModel.sortDescriptors
        #expect(descriptors.first?.key == "dueDate")
        #expect(descriptors.first?.ascending == true)
    }
}
