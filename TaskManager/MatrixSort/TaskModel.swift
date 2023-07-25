
import Foundation
import SwiftUI
import UniformTypeIdentifiers

let ToDoTaskUTI: String = UTType.data.identifier

enum TaskPriority: String, Codable, CaseIterable {
    case notImportant = "Not Important"
    case notUrgent = "Not Urgent"
    case important = "Important"
    case urgent = "Urgent"
    
//    var rawValue: String {
//        switch self {
//        case .important: return "Imporant"
//        case .notImportant: return "Not Imporant"
//        case .urgent: return "Urgent"
//        case .notUrgent: return "Not urgent"
//        }
//    }
}

/// Note: Does not the the _ObjectiveCBridgable protocol
///The _ObjectiveCBridgeable protocol is used for bridging Swift types to Objective-C and vice versa, which allows Swift classes to interoperate with Objective-C code. In other words, it allows Swift types to be used as if they were Objective-C types when calling Objective-C APIs.
///
///The NSItemProviderWriting and NSItemProviderReading protocols, on the other hand, are the ones required for implementing drag and drop functionality. These protocols allow an object to be provided as an item that can be used for drag and drop operations in the user interface. NSItemProviderWriting protocol is used to write out data types for dragging operation, and NSItemProviderReading is used to read data types during a dropping operation.
final class ToDoTask: NSObject, Codable, NSItemProviderWriting, NSItemProviderReading/*, _ObjectiveCBridgeable*/ {
    //    func _bridgeToObjectiveC() -> NSObject {
    //        <#code#>
    //    }
    //
    //    static func _forceBridgeFromObjectiveC(_ source: NSObject, result: inout ToDoTask?) {
    //        result = ToDoTask(id: source.id, name: source.name, priority: source.priority)
    //    }
    //
    //    static func _conditionallyBridgeFromObjectiveC(_ source: NSObject, result: inout ToDoTask?) -> Bool {
    //        <#code#>
    //    }
    //
    //    static func _unconditionallyBridgeFromObjectiveC(_ source: NSObject?) -> Self {
    //        <#code#>
    //    }
    //
    //    typealias _ObjectiveCType = AnyClass
    
    
    //static var readableTypeIdentifiersForItemProvider: [String] = [ToDoTaskUTI]
    /// the type of data this task can be read from, in this case, raw data
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [ToDoTaskUTI]
    }

    // static var writableTypeIdentifiersForItemProvider: [String] = [ToDoTaskUTI]
    /// the type of data this task can be written to, in this case, raw data
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
    let priority: TaskPriority
    
    
    init(id: String, name: String, priority: TaskPriority) {
        self.id = id
        self.title = priority.rawValue
        self.name = name
        self.priority = priority
    }
}

