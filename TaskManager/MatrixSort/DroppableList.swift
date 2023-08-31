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
    
    let action: ((ToDoTask, Int) -> Void)?
    
    init(_ title: String, tasks: Binding<[ToDoTask]>, action: ((ToDoTask, Int) -> Void)?) {
        self.title = title
        self._tasks = tasks
        self.action = action
    }
    
    var body: some View {
        NavigationView {
            List {
                Text(title)
                    .font(.subheadline)
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
                
            }
        }
    }
    
    private func moveUser(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    private func dropTask(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
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
    @ObservedObject var viewModel = MatrixViewModel()
    
   
    
    
    
    @State var fromList = ""
    
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
                DroppableList(TaskPriority.urgent.rawValue, tasks: viewModel.getTasks(by: TaskPriority.urgent)) { droppedTask, index in
                    viewModel.moveTask(droppedTask, to: TaskPriority.urgent)
//                    tasks[TaskPriority.urgent, default: []].append(droppedTask)
//                    guard let origin = TaskPriority(rawValue: droppedTask.priority.rawValue) else {return }
//                    droppedTask.priority = TaskPriority.urgent
//                    tasks[origin]?.removeAll {$0.id == droppedTask.id}
                }
                
                DroppableList(TaskPriority.notUrgent.rawValue, tasks: viewModel.getTasks(by: TaskPriority.notUrgent)) { droppedTask, index in
                    viewModel.moveTask(droppedTask, to: TaskPriority.notUrgent)
//                    tasks[TaskPriority.notUrgent, default: []].append(droppedTask)
//                    guard let origin = TaskPriority(rawValue: droppedTask.priority.rawValue) else {return }
//                    droppedTask.priority = TaskPriority.notUrgent
//                    tasks[origin]?.removeAll {$0.id == droppedTask.id}
                }
            }
            HStack(spacing: 0) {
                DroppableList(TaskPriority.important.rawValue, tasks:viewModel.getTasks(by: TaskPriority.important)) { droppedTask, index in
                    viewModel.moveTask(droppedTask, to: TaskPriority.important)
//                    tasks[TaskPriority.important, default: []].append(droppedTask)
//                    guard let origin = TaskPriority(rawValue: droppedTask.priority.rawValue) else {return }
//                    droppedTask.priority = TaskPriority.important
//                    tasks[origin]?.removeAll {$0.id == droppedTask.id}
                }
                DroppableList(TaskPriority.notImportant.rawValue, tasks: viewModel.getTasks(by: TaskPriority.notImportant)) { droppedTask, index in
                    viewModel.moveTask(droppedTask, to: TaskPriority.notImportant)
//                    tasks[TaskPriority.notImportant, default: []].append(droppedTask)
//                    guard let origin = TaskPriority(rawValue: droppedTask.priority.rawValue) else {return } //todo: rewrite
//                    droppedTask.priority = TaskPriority.notImportant
//                    tasks[origin]?.removeAll {$0.id == droppedTask.id}
                    
                }
            }
        }
    }
}


class MatrixViewModel: ObservableObject {
//    @State var tasks = [TaskPriority: [ToDoTask]]()
    @State var tasks: [TaskPriority: [ToDoTask]] = [TaskPriority.urgent:
                                                        [ToDoTask(id: "123", name: "Wash the dishes", priority: .urgent),
                                                         ToDoTask(id: "321", name: "Pay Gay's insurence", priority: .urgent)],
                                                    TaskPriority.notUrgent:
                                                        [ToDoTask(id: "113", name: "Cook the dinner", priority: .notUrgent),
                                                         ToDoTask(id: "311", name: "Meet with friends", priority: .notUrgent)],
                                                    TaskPriority.important:
                                                        [ToDoTask(id: "111", name: "nnd", priority: .important)],
                                                    TaskPriority.notImportant:
                                                        [ToDoTask(id: "444", name: "jdkds", priority: .notImportant)]
    ]
    
     func getTasks(by priority: TaskPriority) -> Binding<[ToDoTask]> {
        let valueBinding = Binding<[ToDoTask]> (
            get: { [self] in tasks[priority, default: [] ]} ,
            set: { [self] in tasks[priority] = $0}
        )
        return valueBinding
    }
    
    init() {
        // setup task from Swift DAta
    }
    
    func moveTask(_ task: ToDoTask, to: TaskPriority) {
        // fetch the task priority from task.priority
        // delete it
        // update Task priority
        // add it to the new list
        var movingTaskPriority = task.priority
        let movingTask = ToDoTask(id: task.id, name: task.name, priority: TaskPriority(rawValue: to.rawValue)!)
        tasks[TaskPriority(rawValue: to.rawValue)!, default: []].append(movingTask)
        
        print(tasks[TaskPriority(rawValue: to.rawValue)!])
        try tasks[TaskPriority(from: to as! Decoder)]
        
        tasks[TaskPriority(rawValue: movingTaskPriority.rawValue)!]!.removeAll {$0.id == task.id}
        movingTaskPriority = TaskPriority(rawValue: to.rawValue)!
        task.priority = TaskPriority(rawValue: to.rawValue)!
        
    }
}
