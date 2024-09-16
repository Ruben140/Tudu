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
    func addItem(title: String, deadline: Date) {
        let newItem = TodoItem(id: UUID(), title: title, deadlineDate: deadline, isCompleted: false)
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
    
    func updateTitle(for item: TodoItem, newTitle: String){
        if let index = items.firstIndex(where: { $0.id == item.id }){
            items[index].title = newTitle
        }
    }
    
    // Update todo title and deadline
    func updateItem(item: TodoItem, newTitle: String, newDeadlineDate: Date){
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].title = newTitle
            items[index].deadlineDate = newDeadlineDate
        }
    }
}
