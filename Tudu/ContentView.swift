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
    @State private var newTodoPriority: Int = 1 // Priority state
    @State private var editingItemID: UUID? = nil
    @State private var editingDateItemID: UUID? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Create TODO section
                HStack {
                    TextField("Enter new todo", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    DatePicker("Deadline", selection: $newDeadlineDate, displayedComponents: .date)
                        .labelsHidden()

                    Button(action: {
                        if !newTodoTitle.isEmpty {
                            viewModel.addItem(title: newTodoTitle, deadline: newDeadlineDate, priority: newTodoPriority)
                            newTodoTitle = ""
                            newDeadlineDate = Date()
                            newTodoPriority = 1
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                    }
                }

                // Priority Stepper
                HStack {
                    Stepper(value: $newTodoPriority, in: 1...5) {
                        Text("Priority: \(newTodoPriority)")
                    }
                    .padding(.horizontal)
                }

                // List of TODOs
                List {
                    ForEach(viewModel.items) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    viewModel.toggleCompletion(of: item)
                                }

                            VStack(alignment: .leading) {
                                // Title editing
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

                                // Deadline editing
                                if editingDateItemID == item.id {
                                    DatePicker("Select new deadline", selection: Binding(
                                        get: { item.deadlineDate },
                                        set: { newDate in
                                            viewModel.updateDeadline(for: item, newDate: newDate)
                                            editingDateItemID = nil
                                        }
                                    ), displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding(.top, 4)
                                } else {
                                    Text("Due: \(formattedDate(item.deadlineDate))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .onTapGesture {
                                            editingDateItemID = item.id
                                        }
                                }

                                // Display and update Priority
                                Text("Priority: \(item.priority)")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        // Increase priority on tap, but ensure it stays within bounds
                                        let newPriority = item.priority % 5 + 1
                                        viewModel.updatePriority(for: item, newPriority: newPriority)
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


#Preview {
    ContentView()
}
