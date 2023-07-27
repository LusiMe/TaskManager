import Foundation
import SwiftUI
import UniformTypeIdentifiers

let ToDoTaskUTI: String = UTType.data.identifier

enum TaskPriority: String, Codable, CaseIterable {
    case notImportant = "Not Important"
    case notUrgent = "Not Urgent"
    case important = "Important"
    case urgent = "Urgent"
}

final class ToDoTask: NSObject, Codable, NSItemProviderWriting, NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [ToDoTaskUTI]
    }

    static var writableTypeIdentifiersForItemProvider: [String] {
        return [ToDoTaskUTI]
    }

    /// Prepares the object for a drag operation by encoding it as JSON.
    /// If the encoding operation fails, it returns the error in the completion handler.
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        guard typeIdentifier == ToDoTaskUTI else {
            // completion handler here with error?
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
    
    /// Creates a new instance of the object by decoding it from JSON.
    /// If the decoding operation fails, it throws the error to the caller.
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let jsonDecoder = JSONDecoder()
        let item = try! jsonDecoder.decode(Self.self, from: data)
        return item
    }

    
    let id: String
    let title: String
    let name: String
    var priority: TaskPriority
    
    
    init(id: String, name: String, priority: TaskPriority) {
        self.id = id
        self.title = priority.rawValue
        self.name = name
        self.priority = priority
    }
}
