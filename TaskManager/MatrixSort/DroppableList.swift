
import SwiftUI
//drag and drop between 2 tables

enum ListId {
    case urgent
    case notUrgent
    case important
    case notImportant
}

struct DroppableList: View {
    let title: String
    @Binding var tasks: [String]
    @Binding var listId: String
    
    init(_ title: String, tasks: Binding<[String]>, listId:Binding<String>) {
        self.title = title
        self._tasks = tasks
        self._listId = listId
    }
    
    var body: some View {
        NavigationView {
            List {
                Text(title)
                    .font(.subheadline)
                ForEach(tasks, id:\.self) { task in
                    Text(task)
                        .onDrag {
                            listId = self.title
                            print(listId)
                            return NSItemProvider(object: task as NSString)
                        }
                }
                .onMove(perform: moveUser)
            }
        }
    }
    
    private func moveUser(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }

    private func dropTask(at index: Int, tasks: [ToDoTask]) {
        
//            tasks[TaskPriority.notUrgent, default: []].append(contentsOf: droppedTask)
//        guard let origin = TaskPriority(rawValue: fromList) else {
//            print("task priority", TaskPriority(rawValue: fromList))
//            return false}
//        tasks[TaskPriority(rawValue: fromList)!]?.removeAll {$0.id == droppedTask[0].id}
    }
}

struct TwoListsView: View {
    
   @State var tasks: [TaskPriority: [ToDoTask]] = [:]
    
    @State var urgent = ["Wash the dishes", "Pay Gay's insurence", "Go to the gym"]
    @State var notUrgent = ["Meet with friends", "Cook the dinner", "Plan vacation"]
    @State var important = [""]
    @State var notImportant = [""]
    
    @State var fromList = ""
    
    mutating func addTasks() {
        let task1 = ToDoTask(id: "123", note: nil, priority: .urgent)
        let task2 = ToDoTask(id: "124", note: nil, priority: .important)
        tasks[task2.priority] = [task2]
        tasks[.urgent, default: []].append(task1)
        print(tasks)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Eisenhover Matrix")
                    .font(.headline)
                Spacer()
                EditButton()
                Spacer()
                    .frame(width: 10)
            }
            
            HStack(spacing: 0) {
                DroppableList(TaskPriority.urgent.rawValue, tasks: $urgent, listId: $fromList)
                    .dropDestination(for: ToDoTask.self) { droppedTask, index in
//                    urgent.insert(dropped, at: index)
                        tasks[TaskPriority.urgent, default: []].append(contentsOf: droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return false}
                        tasks[origin]?.removeAll {$0.id == droppedTask[0].id}
                        return true
                }
                
                DroppableList("Not urgent", tasks: $notUrgent, listId: $fromList)
                    .dropDestination(for: ToDoTask.self) { droppedTask, index in
                        tasks[TaskPriority.notUrgent, default: []].append(contentsOf: droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return false}
                    tasks[origin]?.removeAll {$0.id == droppedTask[0].id}
                        return true
                }
            }
            HStack(spacing: 0) {
                DroppableList("Important", tasks: $important, listId: $fromList)
                    .dropDestination(for: ToDoTask.self) { droppedTask, index in
                        tasks[TaskPriority.important, default: []].append(contentsOf: droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return false}
                    tasks[origin]?.removeAll {$0.id == droppedTask[0].id}
                        return true
                }
                DroppableList("Not important", tasks: $notImportant, listId: $fromList)
                    .dropDestination(for: ToDoTask.self) { droppedTask, index in
                        print("task priority", TaskPriority(rawValue: fromList))
                        tasks[TaskPriority.notImportant, default: []].append(contentsOf: droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return false}
                    tasks[origin]?.removeAll {$0.id == droppedTask[0].id}
                        return true
                }
            }
        }
    }
}


