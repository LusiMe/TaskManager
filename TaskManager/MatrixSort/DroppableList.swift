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
    
    private func getTasks(by priority: TaskPriority) -> Binding<[ToDoTask]> {
        let valueBinding = Binding<[ToDoTask]> (
            get: {tasks[priority, default: [] ]} ,
            set: {tasks[priority] = $0}
        )
        return valueBinding
    }
    
    @State var fromList = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 0) {
                    DroppableList(TaskPriority.urgent.rawValue, tasks: getTasks(by: TaskPriority.urgent), listId: $fromList) { droppedTask, index in
                        tasks[TaskPriority.urgent, default: []].append(droppedTask)
                        guard let origin = TaskPriority(rawValue: droppedTask.priority.rawValue) else {return }
                        droppedTask.priority = TaskPriority.urgent
                        tasks[origin]?.removeAll {$0.id == droppedTask.id}
                    }
                    
                    DroppableList(TaskPriority.notUrgent.rawValue, tasks:getTasks(by: TaskPriority.notUrgent), listId: $fromList) { droppedTask, index in
                        tasks[TaskPriority.notUrgent, default: []].append(droppedTask)
                        guard let origin = TaskPriority(rawValue: droppedTask.priority.rawValue) else {return }
                        droppedTask.priority = TaskPriority.notUrgent
                        tasks[origin]?.removeAll {$0.id == droppedTask.id}
                    }
                }
                HStack(spacing: 0) {
                    DroppableList(TaskPriority.important.rawValue, tasks:getTasks(by: TaskPriority.important), listId: $fromList) { droppedTask, index in
                        tasks[TaskPriority.important, default: []].append(droppedTask)
                        guard let origin = TaskPriority(rawValue: droppedTask.priority.rawValue) else {return }
                        droppedTask.priority = TaskPriority.important
                        tasks[origin]?.removeAll {$0.id == droppedTask.id}
                    }
                    DroppableList(TaskPriority.notImportant.rawValue, tasks:getTasks(by: TaskPriority.notImportant), listId: $fromList) { droppedTask, index in
                        tasks[TaskPriority.notImportant, default: []].append(droppedTask)
                        guard let origin = TaskPriority(rawValue: droppedTask.priority.rawValue) else {return } //todo: rewrite
                        droppedTask.priority = TaskPriority.notImportant
                        tasks[origin]?.removeAll {$0.id == droppedTask.id}
                        
                    }
                }
            }
            .navigationTitle("Eisenhover Matrix")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                EditButton()
            }
        }
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
