import Foundation

enum SortOption: CaseIterable {
    case `default`
    case dueDateAsc
    case createdDesc
}

func sortTasks(_ items: [TaskItem], by option: SortOption) -> [TaskItem] {
    switch option {
    case .default:
        return items.sorted { a, b in
            if a.isCompleted != b.isCompleted { return a.isCompleted == false }
            let ad = a.createdAt ?? .distantPast
            let bd = b.createdAt ?? .distantPast
            if ad != bd { return ad > bd }
            return (a.title ?? "") < (b.title ?? "")
        }
    case .dueDateAsc:
        return items.sorted { a, b in
            switch (a.dueDate, b.dueDate) {
            case (nil, nil):
                return (a.title ?? "") < (b.title ?? "")
            case (nil, _):
                return false
            case (_, nil):
                return true
            case let (ad?, bd?):
                if ad != bd { return ad < bd }
                return (a.title ?? "") < (b.title ?? "")
            }
        }
    case .createdDesc:
        return items.sorted { a, b in
            let ad = a.createdAt ?? .distantPast
            let bd = b.createdAt ?? .distantPast
            if ad != bd { return ad > bd }
            return (a.title ?? "") < (b.title ?? "")
        }
    }
}
