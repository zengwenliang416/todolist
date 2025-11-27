import Testing
@testable import MacToDo
import CoreData

@MainActor
struct PersistenceTests {
    @Test
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
        #expect(result.count == 3)
        // Note: Sort logic check
        // i=0: completed=true, created=base
        // i=1: completed=false, created=base+10
        // i=2: completed=false, created=base+20
        // Sort: isCompleted asc (false first), createdAt desc (newest first)
        // Expected order:
        // 1. completed=false, created=base+20 (i=2)
        // 2. completed=false, created=base+10 (i=1)
        // 3. completed=true, created=base (i=0)
        
        #expect(result.first?.isCompleted == false)
        #expect(result.first?.title == "T2")
    }

    @Test
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
        #expect(result.count == 1)
        #expect(result.first?.category == "Work")
    }

    @Test
    func testUniqueIDConstraint() throws {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.container.viewContext
        // Set strict merge policy to detect constraint violations
        ctx.mergePolicy = NSErrorMergePolicy
        
        let id = UUID()
        let a = TaskItem(context: ctx)
        a.id = id; a.title = "A"; a.createdAt = Date()
        try ctx.save()
        let b = TaskItem(context: ctx)
        b.id = id; b.title = "B"; b.createdAt = Date()
        
        do {
            try ctx.save()
            #expect(Bool(false), "Expected unique constraint violation")
        } catch {
            // Success: error caught
        }
    }
}
