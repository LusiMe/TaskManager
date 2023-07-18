
//TODO: use new swiftUI stuff
//TODO: Add storage for tasks
import SwiftUI

struct ContentView: View {
    @State var task: String = ""
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField(
                        "Write the task",
                        text: $task
                    )
                    .onSubmit {
                        viewModel.add(task)
                        task = ""
                    }
                    .submitLabel(.send)
                    .cornerRadius(10)
                }
                Section {
                    ForEach(viewModel.todoList, id: \.self) {
                        task in Text(task)
                    }
                    .onDelete{ viewModel.todoList.remove(atOffsets: $0)}
                    .onMove {viewModel.todoList.move(fromOffsets: $0, toOffset: $1)}
                }
                .onSubmit {
                    viewModel.add(task)
                }
            }
        }
        .navigationTitle("To Do")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
