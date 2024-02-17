//
//  Comment.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 17/02/2024.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
