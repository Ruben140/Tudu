//
//  TodoViewModel.swift
//  Tudu
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation

class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = []{
        didSet {
            saveItems()
        }
    }
    
    private let itemsKey = "todoItems"
    
    init(){
        loadItems()
    }
    
    // Add a TODO
    func addItem(title: String, deadline: Date, priority: Int) {
        let newItem = TodoItem(id: UUID(), title: title, deadlineDate: deadline, isCompleted: false, priority: priority)
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
    
    // Update todo title/text
    func updateTitle(for item: TodoItem, newTitle: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].title = newTitle
        }
    }

    // Update todo deadline
    func updateDeadline(for item: TodoItem, newDate: Date) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].deadlineDate = newDate
        }
    }
    
    // Update todo priority
    func updatePriority(for item: TodoItem, newPriority: Int){
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].priority = newPriority
        }
    }
    
    // Save todos to phone
    private func saveItems() {
        let encoder = JSONEncoder()
        if let encodedItems = try? encoder.encode(items){
            UserDefaults.standard.set(encodedItems, forKey: itemsKey)
        }
    }
    
    // Load todos from phone
    private func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: itemsKey) {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([TodoItem].self, from: savedItems){
                self.items = loadedItems
            }
        }
    }
}
