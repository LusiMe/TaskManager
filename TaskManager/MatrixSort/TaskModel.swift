
import Foundation
import SwiftUI
import UniformTypeIdentifiers

enum TaskPriority: String, Codable, CaseIterable {
  case notImportant
  case notUrgent
  case important
  case urgent
    
  var rawValue: String {
    switch self {
    case .important: return "Imporant"
    case .notImportant: return "Not Imporant"
    case .urgent: return "Urgent"
    case .notUrgent: return "Not urgent"
    }
  }
}

struct ToDoTask: Codable, Identifiable, Transferable {
  let id: String
  let title: String
  let note: String?
  let priority: TaskPriority
    
    
  init(id: String, note: String?, priority: TaskPriority) {
    self.id = id
    self.title = priority.rawValue
    self.note = note
    self.priority = priority
  }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .toDoTask)
    }
}

extension UTType{
    static let toDoTask = UTType(exportedAs: "test.first.luda.TaskManager")
}
