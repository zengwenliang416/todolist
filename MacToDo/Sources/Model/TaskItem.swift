import Foundation
import CoreData

@objc(TaskItem)
public class TaskItem: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var dueDate: Date?
    @NSManaged public var category: String?
    @NSManaged public var createdAt: Date?
}

extension TaskItem: Identifiable {
    // Helper to get non-optional values for View
    public var wrappedTitle: String {
        title ?? "New Task"
    }
    
    public var wrappedCategory: String {
        category ?? "Personal"
    }
}
