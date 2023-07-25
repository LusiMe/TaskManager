
import Foundation
import SwiftUI
import UniformTypeIdentifiers

let ToDoTaskUTI: String = UTType.data.identifier

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

final class ToDoTask: NSObject, Codable, NSItemProviderWriting, NSItemProviderReading, _ObjectiveCBridgeable {
    func _bridgeToObjectiveC() -> NSObject {
        <#code#>
    }
    
    static func _forceBridgeFromObjectiveC(_ source: NSObject, result: inout ToDoTask?) {
        result = ToDoTask(id: source.id, name: source.name, priority: source.priority)
    }
    
    static func _conditionallyBridgeFromObjectiveC(_ source: NSObject, result: inout ToDoTask?) -> Bool {
        <#code#>
    }
    
    static func _unconditionallyBridgeFromObjectiveC(_ source: NSObject?) -> Self {
        <#code#>
    }
    
    typealias _ObjectiveCType = AnyClass
    
    
    static var readableTypeIdentifiersForItemProvider: [String] = [ToDoTaskUTI]

    static var writableTypeIdentifiersForItemProvider: [String] = [ToDoTaskUTI]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
              guard typeIdentifier == ToDoTaskUTI else {
                  return progress
              }
              do {
                  let jsonEncoder = JSONEncoder()
                  let data = try jsonEncoder.encode(self)
                  completionHandler(data, nil)
              }
              catch { completionHandler(nil, error) }
              return progress
          }
    
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let jsonDecoder = JSONDecoder()
    let item = try! jsonDecoder.decode(Self.self, from: data)
               return item
    }

    
  let id: String
  let title: String
  let name: String
  let priority: TaskPriority
    
    
  init(id: String, name: String, priority: TaskPriority) {
    self.id = id
    self.title = priority.rawValue
    self.name = name
    self.priority = priority
  }
}

