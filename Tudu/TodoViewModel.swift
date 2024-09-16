//
//  TodoViewModel.swift
//  Tudu
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation

class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    
    // Add a TODO
    func addItem(title: String) {
        let newItem = TodoItem(title: title)
        items.append(newItem)
    }
    
    // Remove a TODO
    func deleteItem(at offsets: IndexSet){
        items.remove(atOffsets: offsets)
    }
    
    // Toggle completion status of a TODO
    func toggleCompletion(of item: TodoItem){
        if let index = items.firstIndex(where: {$0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
}
