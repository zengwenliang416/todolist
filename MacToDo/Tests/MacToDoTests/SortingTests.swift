import CoreData
import Foundation
@testable import MacToDo
import Testing

@MainActor
struct SortingTests {
    @Test
    func dueDateAscendingSort() throws {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.container.viewContext
        let a = TaskItem(context: ctx)
        a.id = UUID(); a.title = "A"; a.createdAt = Date(); a.dueDate = Date().addingTimeInterval(3_600)
        let b = TaskItem(context: ctx)
        b.id = UUID(); b.title = "B"; b.createdAt = Date(); b.dueDate = Date().addingTimeInterval(1_800)
        let c = TaskItem(context: ctx)
        c.id = UUID(); c.title = "C"; c.createdAt = Date(); c.dueDate = nil
        try ctx.save()
        let items = [a, b, c]
        let sorted = sortTasks(items, by: .dueDateAsc)
        #expect(sorted.first?.title == "B")
        #expect(sorted[1].title == "A")
        #expect(sorted.last?.title == "C")
    }
}
