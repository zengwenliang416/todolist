import XCTest
@testable import MacToDo
import CoreData

final class PersistenceTests: XCTestCase {
    func testCreateAndFetchTasks() throws {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.container.viewContext
        for i in 0..<3 {
            let t = TaskItem(context: ctx)
            t.id = UUID()
            t.title = "T\(i)"
            t.isCompleted = i == 0
            t.category = i % 2 == 0 ? "Work" : "Personal"
            t.createdAt = Date().addingTimeInterval(Double(i) * 10)
        }
        try ctx.save()

        let req = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        req.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskItem.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TaskItem.createdAt, ascending: false)
        ]
        let result = try ctx.fetch(req)
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result.first?.isCompleted == false)
    }

    func testCategoryFilter() throws {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.container.viewContext
        let a = TaskItem(context: ctx)
        a.id = UUID(); a.title = "A"; a.category = "Work"; a.createdAt = Date()
        let b = TaskItem(context: ctx)
        b.id = UUID(); b.title = "B"; b.category = "Personal"; b.createdAt = Date()
        try ctx.save()

        let req = NSFetchRequest<TaskItem>(entityName: "TaskItem")
        req.predicate = NSPredicate(format: "category == %@", "Work")
        let result = try ctx.fetch(req)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.category, "Work")
    }

    func testUniqueIDConstraint() throws {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.container.viewContext
        let id = UUID()
        let a = TaskItem(context: ctx)
        a.id = id; a.title = "A"; a.createdAt = Date()
        try ctx.save()
        let b = TaskItem(context: ctx)
        b.id = id; b.title = "B"; b.createdAt = Date()
        do {
            try ctx.save()
            XCTFail("Expected unique constraint violation")
        } catch {
            XCTAssertTrue(true)
        }
    }
}
