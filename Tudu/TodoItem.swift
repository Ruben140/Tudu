//
//  TodoItem.swift
//  Tudu
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation

struct TodoItem: Identifiable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var deadlineDate: Date
}
