//
//  Todos.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 17/02/2024.
//

import Foundation


struct Todos: Codable, Identifiable {
    let id : Int
    let userId: Int
    let title: String
    var completed: Bool
}

