import SwiftUI

struct TaskRowView: View {
    @ObservedObject var item: TaskItem
    var onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Button(action: toggleCompletion) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(item.isCompleted ? AppTheme.accent : AppTheme.secondaryText)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.wrappedTitle)
                    .appFont(size: 16, weight: .medium)
                    .strikethrough(item.isCompleted)
                    .foregroundColor(item.isCompleted ? AppTheme.secondaryText : AppTheme.primaryText)

                if let date = item.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(date, style: .date)
                        Text(date, style: .time)
                    }
                    .font(.caption)
                    .foregroundColor(isOverdue ? .red : .secondary)
                }
            }

            Spacer()

            if let categoryName = item.category, let cat = TaskCategory(rawValue: categoryName) {
                Text(cat.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(cat.color.opacity(0.1))
                    .foregroundColor(cat.color)
                    .cornerRadius(6)
            }
        }
        .padding(12)
        .cardStyle()
        .padding(.horizontal)
        .padding(.vertical, 4)
    }

    private var isOverdue: Bool {
        guard let date = item.dueDate else { return false }
        return date < Date() && !item.isCompleted
    }

    private func toggleCompletion() {
        withAnimation(.spring()) {
            onToggle()
        }
    }
}
