import SwiftUI
import os

struct TaskRowView: View {
    @ObservedObject var item: TaskItem
    @Environment(\.managedObjectContext) private var viewContext
    private let logger = Logger(subsystem: "com.example.mactodo", category: "TaskRow")
    
    var body: some View {
        HStack(spacing: 16) {
            // Sketchy Checkbox
            ZStack {
                // Hand-drawn box
                RoundedRectangle(cornerRadius: 8)
                    .stroke(SketchTheme.pencilGraphite, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [40, 2], dashPhase: 5))
                    .frame(width: 24, height: 24)
                    .rotationEffect(.degrees(Double.random(in: -2...2)))
                
                if item.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(SketchTheme.pencilGraphite) // Pencil mark
                        .rotationEffect(.degrees(-5))
                }
            }
            .contentShape(Rectangle()) // Make tap area larger
            .onTapGesture {
                toggleCompletion()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.wrappedTitle)
                    .sketchFont(size: 18, weight: .regular)
                    // Custom strikethrough for compatibility and style
                    .overlay(
                        item.isCompleted ? 
                            Rectangle()
                                .fill(SketchTheme.pencilGraphite)
                                .frame(height: 1)
                                .offset(y: 1)
                                .rotationEffect(.degrees(-1))
                            : nil
                    )
                    .foregroundColor(item.isCompleted ? SketchTheme.pencilGray : SketchTheme.pencilGraphite)
                    .opacity(item.isCompleted ? 0.6 : 1.0)
                
                if let date = item.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(date, style: .date)
                        Text(date, style: .time)
                    }
                    .sketchFont(size: 14)
                    .foregroundColor(date < Date() && !item.isCompleted ? Color.red.opacity(0.7) : SketchTheme.pencilGray)
                }
            }
            
            Spacer()
            
            if let categoryName = item.category, let cat = TaskCategory(rawValue: categoryName) {
                HStack(spacing: 4) {
                    Image(systemName: cat.icon)
                        .font(.system(size: 12))
                    Text(cat.rawValue)
                        .sketchFont(size: 12)
                }
                .foregroundColor(SketchTheme.pencilGraphite)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(cat.highlightColor)
                        .rotationEffect(.degrees(Double.random(in: -2...2)))
                )
            }
        }
        .padding(16)
        .glassySketchStyle()
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private func toggleCompletion() {
        withAnimation(.spring()) {
            item.isCompleted.toggle()
            do {
                try viewContext.save()
            } catch {
                logger.error("Error saving: \(String(describing: error))")
            }
        }
    }
}
