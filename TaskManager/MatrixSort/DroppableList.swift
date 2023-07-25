
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
    @Binding var tasks: [ToDoTask]
    @Binding var listId: String
    
    let action: ((ToDoTask, Int) -> Void)?
    
    init(_ title: String, tasks: Binding<[ToDoTask]>, listId:Binding<String>, action: ((ToDoTask, Int) -> Void)?) {
        self.title = title
        self._tasks = tasks
        self._listId = listId
        self.action = action
    }
    
    var body: some View {
        NavigationView {
            List {
                Text(title)
                    .font(.subheadline)
                    .onDrop(of: [.plainText], isTargeted: nil, perform: dropOnEmptyList)
                ForEach(tasks, id:\.self) { task in
                    Text(task.title)
                        .onDrag {NSItemProvider(object: task as ToDoTask)}
                }
                .onMove(perform: moveUser)
                .onInsert(of: [ToDoTaskUTI], perform: dropTask)
            }
        }
    }
    
    private func moveUser(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    private func dropTask(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            _ = item.loadObject(ofClass: ToDoTask.self) { droppedTask, _ in
                if let ss = droppedTask, let dropAction = action {
                    DispatchQueue.main.async {
                        dropAction(ss, index)
                    }
                }
            }
        }
    }
    
    private func dropOnEmptyList(items: [NSItemProvider]) -> Bool {
        dropTask(at: tasks.endIndex, items)
        return true
    }
}


struct TwoListsView: View {
    
    @State var tasks: [TaskPriority: [ToDoTask]] = [:]
    
    @State var urgent = [ToDoTask(id: "123", name: "Wash the dishes", priority: .urgent),
                         ToDoTask(id: "321", name: "Pay Gay's insurence", priority: .urgent)]
//    ["Wash the dishes", "Pay Gay's insurence", "Go to the gym"]
    @State var notUrgent = [ToDoTask(id: "113", name: "Cook the dinner", priority: .notUrgent),
                           ToDoTask(id: "311", name: "Meet with friends", priority: .notUrgent)]
//    ["Meet with friends", "Cook the dinner", "Plan vacation"]
    @State var important = [ToDoTask(id: "111", name: "nnd", priority: .important)]
    @State var notImportant = [ToDoTask(id: "444", name: "jdkds", priority: .notImportant)]
    
    @State var fromList = ""
    
    mutating func addTasks() {
//        let task1 = ToDoTask(id: "123", note: nil, priority: .urgent)
//        let task2 = ToDoTask(id: "124", note: nil, priority: .important)
//        tasks[task2.priority] = [task2]
//        tasks[.urgent, default: []].append(task1)
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
                DroppableList(TaskPriority.urgent.rawValue, tasks: $urgent, listId: $fromList) { droppedTask, index in
                    tasks[TaskPriority.urgent, default: []].append(droppedTask)
                        guard let origin = TaskPriority(rawValue: fromList) else {return }
                        tasks[origin]?.removeAll {$0.id == droppedTask.id}
                        return true
                    }
                
                DroppableList("Not urgent", tasks: $notUrgent, listId: $fromList) { droppedTask, index in
                    tasks[TaskPriority.notUrgent, default: []].append(contentsOf: droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return }
                    tasks[origin]?.removeAll {$0.id == droppedTask[0].id}
                }
            }
            HStack(spacing: 0) {
                DroppableList("Important", tasks: $important, listId: $fromList) { droppedTask, index in
                    tasks[TaskPriority.important, default: []].append(contentsOf: droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return false}
                    tasks[origin]?.removeAll {$0.id == droppedTask[0].id}
                    return true
                }
                DroppableList("Not important", tasks: $notImportant, listId: $fromList) { droppedTask, index in
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


