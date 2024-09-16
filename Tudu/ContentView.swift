//
//  ContentView.swift
//  Tudu
//
//  Created by Ruben de Koning on 16/09/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TodoViewModel()
    @State private var newTodoTitle: String = ""
    @State private var newDeadlineDate: Date = Date()
    @State private var editingItemID: UUID? = nil
    @State private var editingDateItemID: UUID? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter new todo", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    DatePicker("Deadline", selection: $newDeadlineDate, displayedComponents: .date)
                        .labelsHidden()
                    
                    Button(action: {
                        if !newTodoTitle.isEmpty {
                            viewModel.addItem(title: newTodoTitle, deadline: newDeadlineDate)
                            newTodoTitle = ""
                            newDeadlineDate = Date()
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                    }
                }
                
                List {
                    ForEach(viewModel.items, id: \.id) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    viewModel.toggleCompletion(of: item)
                                }
                            
                            VStack(alignment: .leading) {
                                if editingItemID == item.id {
                                    TextField("Edit title", text: Binding(
                                        get: { item.title },
                                        set: { newValue in
                                            viewModel.updateTitle(for: item, newTitle: newValue)
                                        }
                                    ))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onSubmit {
                                        editingItemID = nil
                                    }
                                } else {
                                    Text(item.title)
                                        .strikethrough(item.isCompleted)
                                        .foregroundColor(item.isCompleted ? .gray : .black)
                                        .onTapGesture {
                                            editingItemID = item.id
                                        }
                                }
                                
                                if editingDateItemID == item.id {
                                    // Show the DatePicker if we're editing this item's date
                                    DatePicker("Select new deadline", selection: Binding(
                                        get: { item.deadlineDate },
                                        set: { newDate in
                                            viewModel.updateItem(item: item, newTitle: item.title, newDeadlineDate: newDate)
                                            editingDateItemID = nil // Stop editing after selecting a date
                                        }
                                    ), displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding(.top, 4)
                                } else {
                                    // Show the due date text and allow tap to start editing
                                    Text("Due: \(formattedDate(item.deadlineDate))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .onTapGesture {
                                            editingDateItemID = item.id // Start editing the date
                                        }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }
            }
            .navigationTitle("Tudu")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct EditDeadlineView: View {
    @ObservedObject var viewModel: TodoViewModel
    var item: TodoItem
    @Binding var isPresented: Bool
    @State private var updatedTitle: String
    @State private var updatedDeadlineDate: Date
    
    init(viewModel: TodoViewModel, item: TodoItem, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.item = item
        _updatedTitle = State(initialValue: item.title)
        _updatedDeadlineDate = State(initialValue: item.deadlineDate)
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit TODO")
                    .font(.headline)
                    .padding()
                
                TextField("Edit task title", text: $updatedTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                DatePicker("Select new deadline", selection: $updatedDeadlineDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                Spacer()
                
                HStack{
                    Button("Cancel") {
                        isPresented = false
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button("Save") {
                        viewModel.updateItem(item: item, newTitle: updatedTitle, newDeadlineDate: updatedDeadlineDate)
                        isPresented = false
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
