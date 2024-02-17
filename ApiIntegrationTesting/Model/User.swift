//
//  User.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 17/02/2024.
//

import Foundation

struct Company {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct Address {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
    
    struct Geo {
        let lat: String
        let lng: String
    }
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
    
}
