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
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter new todo", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {if !newTodoTitle.isEmpty {
                        viewModel.addItem(title: newTodoTitle)
                        newTodoTitle = ""
                    }}) {
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
                            
                            Text(item.title)
                                .strikethrough(item.isCompleted)
                                .foregroundColor(item.isCompleted ? .gray : .black)
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
        }
    }
}

#Preview {
    ContentView()
}
