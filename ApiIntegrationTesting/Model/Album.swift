//
//  Album.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation

struct Album: Codable, Identifiable, Hashable{
    let id: Int
    let userId: Int
    let title: String
}
