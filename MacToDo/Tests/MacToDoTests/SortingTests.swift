import XCTest
@testable import MacToDo
import CoreData

final class SortingTests: XCTestCase {
    func testDueDateAscendingSort() throws {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.container.viewContext
        let a = TaskItem(context: ctx)
        a.id = UUID(); a.title = "A"; a.createdAt = Date(); a.dueDate = Date().addingTimeInterval(3600)
        let b = TaskItem(context: ctx)
        b.id = UUID(); b.title = "B"; b.createdAt = Date(); b.dueDate = Date().addingTimeInterval(1800)
        let c = TaskItem(context: ctx)
        c.id = UUID(); c.title = "C"; c.createdAt = Date(); c.dueDate = nil
        try ctx.save()
        let items = [a, b, c]
        let sorted = sortTasks(items, by: .dueDateAsc)
        XCTAssertEqual(sorted.first?.title, "B")
        XCTAssertEqual(sorted[1].title, "A")
        XCTAssertEqual(sorted.last?.title, "C")
    }
}
