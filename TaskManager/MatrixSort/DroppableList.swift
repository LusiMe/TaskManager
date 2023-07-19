
import SwiftUI
//drag and drop between 2 tables

struct DroppableList: View {
    let title: String
    @Binding var tasks: [String]
    let action: ((String, Int) -> Void)?
    
    init(_ title: String, tasks: Binding<[String]>, action: ((String, Int) -> Void)? = nil) {
        self.title = title
        self._tasks = tasks
        self.action = action
    }
    
    var body: some View {
        NavigationView {
            List {
                Text(title)
                    .font(.subheadline)
                    .onDrop(of: [.plainText], isTargeted: nil, perform: dropOnEmptyList)
                ForEach(tasks, id:\.self) { task in
                    Text(task)
                        .onDrag {NSItemProvider(object: task as NSString)}
                }
                .onMove(perform: moveUser)
                .onInsert(of: ["public.text"], perform: dropUser)
            }
        }
    }
    
//    private func removeTask(task: String, from list: inout [String]) {
//        if let index = list.firstIndex(where: {$0 == task}) {
//            list.remove(at: index)
//        }
//    }
    
    private func moveUser(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
    
    private func dropUser(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            _ = item.loadObject(ofClass: String.self) { droppedString, _ in
                if let ss = droppedString, let dropAction = action {
                    DispatchQueue.main.async {
                        dropAction(ss, index)
                    }
                }
            }
        }
    }
    
    private func dropOnEmptyList(items: [NSItemProvider]) -> Bool {
        dropUser(at: tasks.startIndex, items)
        return true
    }
}

struct TwoListsView: View {
    @State var tasks1 = ["Wash the dishes", "Pay Gay's insurence", "Go to the gym"]
    @State var tasks2 = ["Meet with friends", "Cook the dinner", "Plan vacation"]
    @State var tasks3 = [""]
    @State var tasks4 = [""]
    
    //keep where it's coming from?
    //pass unique list id?
    
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
                DroppableList("Urgent", tasks: $tasks1) { dropped, index in //write the func to handle it all instead. where it's from and where to delete it from
                    tasks1.insert(dropped, at: index)
                    tasks2.removeAll {$0 == dropped}
                }
                DroppableList("Not urgent", tasks: $tasks2) { dropped, index in
                    tasks2.insert(dropped, at: index)
                    tasks1.removeAll {$0 == dropped}
                }
            }
            HStack(spacing: 0) {
                DroppableList("Urgent", tasks: $tasks3) { dropped, index in
                    tasks3.insert(dropped, at: index)
                    tasks2.removeAll {$0 == dropped}
                }
                DroppableList("Not urgent", tasks: $tasks4) { dropped, index in
                    tasks4.insert(dropped, at: index)
                    tasks1.removeAll {$0 == dropped}
                }
            }
        }
    }
}


