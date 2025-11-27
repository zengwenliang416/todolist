import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Create the managed object model programmatically
        let model = NSManagedObjectModel()

        // Define TaskItem Entity
        let taskItemEntity = NSEntityDescription()
        taskItemEntity.name = "TaskItem"
        taskItemEntity.managedObjectClassName = "TaskItem"

        // Attributes
        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false

        let titleAttr = NSAttributeDescription()
        titleAttr.name = "title"
        titleAttr.attributeType = .stringAttributeType
        titleAttr.isOptional = false
        titleAttr.defaultValue = "New Task"

        let isCompletedAttr = NSAttributeDescription()
        isCompletedAttr.name = "isCompleted"
        isCompletedAttr.attributeType = .booleanAttributeType
        isCompletedAttr.isOptional = false
        isCompletedAttr.defaultValue = false

        let dateAttr = NSAttributeDescription()
        dateAttr.name = "dueDate"
        dateAttr.attributeType = .dateAttributeType
        dateAttr.isOptional = true

        let categoryAttr = NSAttributeDescription()
        categoryAttr.name = "category"
        categoryAttr.attributeType = .stringAttributeType
        categoryAttr.isOptional = false
        categoryAttr.defaultValue = "Personal"

        let createdAtAttr = NSAttributeDescription()
        createdAtAttr.name = "createdAt"
        createdAtAttr.attributeType = .dateAttributeType
        createdAtAttr.isOptional = false

        taskItemEntity.properties = [idAttr, titleAttr, isCompletedAttr, dateAttr, categoryAttr, createdAtAttr]
        taskItemEntity.uniquenessConstraints = [["id"]]

        // Entity-level indexes
        let idIndex = NSFetchIndexDescription(
            name: "idx_TaskItem_id",
            elements: [NSFetchIndexElementDescription(property: idAttr, collationType: .binary)]
        )
        let categoryIndex = NSFetchIndexDescription(
            name: "idx_TaskItem_category",
            elements: [NSFetchIndexElementDescription(property: categoryAttr, collationType: .binary)]
        )
        let dueDateIndex = NSFetchIndexDescription(
            name: "idx_TaskItem_dueDate",
            elements: [NSFetchIndexElementDescription(property: dateAttr, collationType: .binary)]
        )
        let statusCreatedAtIndex = NSFetchIndexDescription(
            name: "idx_TaskItem_status_createdAt",
            elements: [
                NSFetchIndexElementDescription(property: isCompletedAttr, collationType: .binary),
                NSFetchIndexElementDescription(property: createdAtAttr, collationType: .binary),
            ]
        )
        taskItemEntity.indexes = [idIndex, categoryIndex, dueDateIndex, statusCreatedAtIndex]

        model.entities = [taskItemEntity]

        // Initialize Container with the programmatic model
        container = NSPersistentContainer(name: "MacToDo", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            description.setOption([
                "journal_mode": "WAL",
                "synchronous": "NORMAL",
            ] as NSDictionary, forKey: NSSQLitePragmasOption)
        }

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // Preview helper
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0 ..< 5 {
            let newItem = TaskItem(context: viewContext)
            newItem.id = UUID()
            newItem.title = "Task \(i)"
            newItem.isCompleted = (i % 2 == 0)
            newItem.category = i < 2 ? "Work" : "Personal"
            newItem.createdAt = Date()
            newItem.dueDate = Date().addingTimeInterval(Double(i) * 86_400)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
