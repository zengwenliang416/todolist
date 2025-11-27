import SwiftUI
import UserNotifications
import os

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    private let logger = Logger(subsystem: "com.example.mactodo", category: "AddTask")
    
    @State private var title = ""
    @State private var category: TaskCategory
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    
    private let repository: TaskRepository
    
    init(defaultCategory: TaskCategory, repository: TaskRepository = TaskRepository()) {
        _category = State(initialValue: defaultCategory)
        self.repository = repository
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("New Task")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .keyboardShortcut(.cancelAction)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Form Content
            Form {
                Section {
                    TextField("What needs to be done?", text: $title)
                        .textFieldStyle(.plain)
                        .font(.system(size: 16))
                        .padding(.vertical, 8)
                }
                
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(TaskCategory.allCases.filter { $0 != .all }) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Toggle("Due Date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            
            Divider()
            
            // Footer
            HStack {
                Spacer()
                Button(action: addTask) {
                    Text("Add Task")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .keyboardShortcut(.defaultAction)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(width: 400, height: 450)
    }
    
    private func addTask() {
        withAnimation {
            let date = hasDueDate ? dueDate : nil
            let newItem = repository.addTask(title: title, category: category, date: date)
            
            if hasDueDate {
                scheduleNotification(for: newItem)
            }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func scheduleNotification(for item: TaskItem) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Task Reminder"
                content.body = item.wrappedTitle
                content.sound = .default
                
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.dueDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                let request = UNNotificationRequest(identifier: item.id?.uuidString ?? UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
}
