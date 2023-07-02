//
//  ContentView.swift
//  TaskManager
//
//  Created by Людмила Парфенова on 21/06/2023.
//

//TODO: use new swiftUI stuff
import SwiftUI

struct ContentView: View {
    @State var task: String = ""
    @ObservedObject var viewModel = ViewModel()
    
    //TODO: add tasks to the array
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
