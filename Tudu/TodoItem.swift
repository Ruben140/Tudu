//
//  TodoItem.swift
//  Tudu
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation

struct TodoItem: Identifiable {
    let id: UUID
    var title: String
    var deadlineDate: Date
    var isCompleted: Bool
}
