import SwiftUI
import UserNotifications
import os

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    private let logger = Logger(subsystem: "com.example.mactodo", category: "AddTask")
    
    @State private var title = ""
    @State private var category: TaskCategory
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    
    init(defaultCategory: TaskCategory) {
        _category = State(initialValue: defaultCategory)
    }
    
    var body: some View {
        ZStack {
            // Glass Background
            Rectangle().fill(.regularMaterial).ignoresSafeArea()
            Color.white.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("New Scribble")
                    .sketchFont(size: 24, weight: .bold)
                    .foregroundColor(SketchTheme.pencilGraphite)
                    .padding(.bottom, 10)
                    .background(
                        SketchTheme.highlighterPink
                            .mask(Rectangle().padding(.top, 20))
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("What needs doing?")
                        .sketchFont(size: 14, weight: .medium)
                        .foregroundColor(SketchTheme.pencilGray)
                    
                    TextField("E.g., Buy sketchpad", text: $title)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(12)
                        .glassySketchStyle()
                        .sketchFont(size: 16)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .sketchFont(size: 14, weight: .medium)
                        .foregroundColor(SketchTheme.pencilGray)
                    
                    Picker("Category", selection: $category) {
                        ForEach(TaskCategory.allCases.filter { $0 != .all }) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .glassySketchStyle()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Set Deadline", isOn: $hasDueDate)
                        .toggleStyle(SwitchToggleStyle(tint: SketchTheme.marginPink))
                        .sketchFont(size: 16, weight: .medium)
                    
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                            .padding(8)
                            .glassySketchStyle()
                    }
                }
                
                HStack(spacing: 16) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Scrap It")
                            .sketchFont(size: 16, weight: .medium)
                            .foregroundColor(SketchTheme.pencilGray)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(SketchTheme.pencilGray, style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .keyboardShortcut(.cancelAction)
                    
                    Button(action: addTask) {
                        Text("Pin It")
                            .sketchFont(size: 16, weight: .bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .background(
                                ZStack {
                                    if !title.isEmpty {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(SketchTheme.pencilGraphite)
                                            .opacity(0.8) // Slightly transparent for glass feel
                                        // Scribble effect
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(SketchTheme.pencilGraphite, lineWidth: 2)
                                            .offset(x: 2, y: 2)
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.3))
                                    }
                                }
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(title.isEmpty)
                    .keyboardShortcut(.defaultAction)
                }
                .padding(.top, 10)
            }
            .padding(32)
            .frame(width: 400) // Fixed width for dialog feel
        }
        .frame(width: 400, height: 450)
    }
    
    private func addTask() {
        let newTask = TaskItem(context: viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.isCompleted = false
        newTask.createdAt = Date()
        newTask.category = category.rawValue
        
        if hasDueDate {
            newTask.dueDate = dueDate
            scheduleNotification(for: newTask)
        }
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            logger.error("Error saving task: \(String(describing: error))")
        }
    }
    
    private func scheduleNotification(for task: TaskItem) {
        guard let date = task.dueDate, date > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(task.wrappedTitle)"
        content.body = "It's time to tackle this task!"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id?.uuidString ?? UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
