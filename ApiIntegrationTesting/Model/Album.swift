//
//  Album.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation

struct Album: Codable, Identifiable{
    let userId: Int
    let id: Int
    let title: String
}
