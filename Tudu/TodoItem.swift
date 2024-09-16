//
//  TodoItem.swift
//  Tudu
//
//  Created by Ruben de Koning on 16/09/2024.
//

import Foundation

struct TodoItem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var deadlineDate: Date
    var isCompleted: Bool
    var priority: Int
}
