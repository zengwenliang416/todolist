import CoreData
import SwiftUI

/// A repository that handles all Core Data operations for TaskItems.
class TaskRepository {
    private let context: NSManagedObjectContext

    /// Initialize with a context, defaulting to the shared persistence controller's viewContext.
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    /// Adds a new task.
    /// - Returns: The created task item.
    @MainActor
    @discardableResult
    func addTask(title: String, category: TaskCategory, date: Date?) -> TaskItem {
        let newTask = TaskItem(context: context)
        newTask.id = UUID()
        newTask.title = title
        newTask.category = category.rawValue
        newTask.createdAt = Date()
        newTask.isCompleted = false
        newTask.dueDate = date
        save()
        return newTask
    }

    /// Deletes a task.
    /// - Parameter item: The task to delete.
    @MainActor
    func delete(_ item: TaskItem) {
        context.delete(item)
        save()
    }

    /// Toggles the completion status of a task.
    /// - Parameter item: The task to update.
    @MainActor
    func toggleCompletion(_ item: TaskItem) {
        item.isCompleted.toggle()
        save()
    }
    
    /// Updates the task details.
    @MainActor
    func updateTask(_ item: TaskItem, title: String, date: Date?) {
        item.title = title
        item.dueDate = date
        save()
    }

    /// Saves the context if there are changes.
    @MainActor
    private func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            // In a real app, we should handle this more gracefully (e.g., show an alert, log to a service)
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
