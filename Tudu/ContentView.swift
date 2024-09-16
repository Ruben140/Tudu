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
    @State private var isEditingDeadlineDate: Bool = false
    @State private var selectedItem: TodoItem?
    
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
                    ForEach(viewModel.items) {
                        item in
                            HStack{
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        viewModel.toggleCompletion(of: item)
                                    }
                                
                                VStack(alignment: .leading){
                                    Text(item.title)
                                        .strikethrough(item.isCompleted)
                                        .foregroundColor(item.isCompleted ? .gray : .black)
                                    
                                    HStack {
                                        Text("Due:\(formattedDate(item.deadlineDate))")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Button("Edit") {
                                            selectedItem = item
                                            isEditingDeadlineDate = true
                                        }
                                        .font(.caption)
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                }
                                
                                Spacer()
                        }
                    }
                    .onDelete(perform:
                        viewModel.deleteItem)
                    }
                }
            .navigationTitle("Tudu")
            .toolbar {
                EditButton()
            }
            .sheet(isPresented: $isEditingDeadlineDate) {
                if let selectedItem = selectedItem {
                    EditDeadlineView(viewModel: viewModel, item: selectedItem, isPresented: $isEditingDeadlineDate)
                }
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
    @State private var newDeadlineDate: Date
    
    init(viewModel: TodoViewModel, item: TodoItem, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.item = item
        _newDeadlineDate = State(initialValue: item.deadlineDate)
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            Text("Edit Deadline")
                .font(.headline)
                .padding()
            
            DatePicker("Select deadline date", selection: $newDeadlineDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Button("Save") {
                viewModel.updateDeadline(for: item, newDeadlineDate: newDeadlineDate)
                isPresented = false
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            Button("Cancel"){
                isPresented = false
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    ContentView()
}
