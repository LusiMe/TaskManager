//
//  ViewModel.swift
//  TaskManager
//
//  Created by Людмила Парфенова on 02/07/2023.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var todoList: [String] = []
    
    func add(_ task: String) {
        guard task.count > 0 else {return}
        
        todoList.insert(task, at: 0)
        //TODO: clean up textfield after
    }
}
