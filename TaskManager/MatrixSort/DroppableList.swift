
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
                    //.onDrop(of: [.plainText], isTargeted: nil, perform: dropOnEmptyList)
                    .onDrop(of: [ToDoTaskUTI], isTargeted: nil) { providers in
                        dropOnEmptyList(items: providers)
                    }
                ForEach(tasks.indices, id:\.self) { index in
                    Text(tasks[index].name)
                        .onDrag {NSItemProvider(object: tasks[index])}
                        .onDrop(of: [ToDoTaskUTI], isTargeted: nil) { providers in
                            dropTask(at: index, providers)
                            return true
                        }
                }
                .onMove(perform: moveUser)
                //.onInsert(of: [ToDoTaskUTI], perform: dropTask)

            }
        }
    }
    
    private func moveUser(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    private func dropTask(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
//            _ = item.loadObject(ofClass: ToDoTask.self) { droppedTask, _ in
//                if let ss = droppedTask, let dropAction = action {
//                    DispatchQueue.main.async {
//                        dropAction(ss, index)
//                    }
//                }
//            }
            if item.canLoadObject(ofClass: ToDoTask.self) {
                _ = item.loadObject(ofClass: ToDoTask.self, completionHandler: { droppedTask, error in
                    if let task = droppedTask as? ToDoTask, let action = action {
                        DispatchQueue.main.async {
                            action(task, index)
                        }
                    }
                })
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

    // These Tasks has not been added to the task list
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
                    }
                
                DroppableList("Not urgent", tasks: $notUrgent, listId: $fromList) { droppedTask, index in
                    tasks[TaskPriority.notUrgent, default: []].append(droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return }
                    tasks[origin]?.removeAll {$0.id == droppedTask.id}
                }
            }
            HStack(spacing: 0) {
                DroppableList("Important", tasks: $important, listId: $fromList) { droppedTask, index in
                    tasks[TaskPriority.important, default: []].append(droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return }
                    tasks[origin]?.removeAll {$0.id == droppedTask.id}
                }
                DroppableList("Not important", tasks: $notImportant, listId: $fromList) { droppedTask, index in
                    print("task priority", TaskPriority(rawValue: fromList))
                    tasks[TaskPriority.notImportant, default: []].append(droppedTask)
                    guard let origin = TaskPriority(rawValue: fromList) else {return }
                    droppedTask.priority
                    tasks[origin]?.removeAll {$0.id == droppedTask.id}
                    
                }
            }
            .onAppear {
                // Set up the task Dictionary?

            }
        }
        /* We successfully added the task to the updated category.
            But we are not removing it from the previous list cause we are looking for fromList which is empty
            We also have to update the TodoTask with new priority each array is not containing the correct priority
         */
    }
}


class viewModel: ObservableObject {
    @State var tasks = [TaskPriority: [ToDoTask]]()

    init() {
        // setup task from Swift DAta
    }

    func moveTask(_ task: ToDoTask, to: TaskPriority) {
        // fetch the task from priority from task.priority
        // delete it
        // update Task priority
        // add it to the new list
    }
}


