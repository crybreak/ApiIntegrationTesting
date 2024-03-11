//
//  User.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 17/02/2024.
//

import Foundation

struct Company: Codable, Hashable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct Address: Codable, Hashable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
    
    struct Geo: Codable, Hashable {
        let lat: String
        let lng: String
    }
}

struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
    
}

extension User {
    
    static func example() -> User {
        let adress = Address(street: "Kulas Light", suite: "Apt. 556", city: "Gwenborough", zipcode: "92998-3874", geo: Address.Geo(lat: "-37.3159", lng: "81.1496"))
        let company = Company(name: "Romaguera-Crona", catchPhrase: "Multi-layered client-server neural-net", bs: "harness real-time e-markets")
        return User(id: 1, name: "Leanne Graham", username: "Bret",
                    email: "Sincere@april.biz", address: adress, phone: "1-770-736-8031 x56442", website: "hildegard.org", company: company)
    }
    
    static func example2() -> User {
        let adress = Address(street: "", suite: "Apt. 556", city: "Gwenborough", zipcode: "92998-3874", geo: Address.Geo(lat: "-37.3159", lng: "81.1496"))
        let company = Company(name: "Romaguera-Crona", catchPhrase: "Multi-layered client-server neural-net", bs: "harness real-time e-markets")
        return User(id: 2, name: "bob", username: "bob", email: "Sincere@april.biz", address: adress, phone: "1-770-736-8031 x56442", website: "hildegard.org", company: company)
    }
}
