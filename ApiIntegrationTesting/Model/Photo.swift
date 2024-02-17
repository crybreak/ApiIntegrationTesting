//
//  Photo.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation
import UIKit

struct Photo: Codable, Identifiable {
    let id: Int
    let albumId: Int
    let title: String
    let largeImagePath: String
    let thumbnailImagePath: String
    
    var thumbnailUIImage: UIImage? = nil
    var isLoading : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, albumId, title
        case largeImagePath = "url"
        case thumbnailImagePath = "thumbnailUrl"
    }
}


extension Photo: CustomStringConvertible {
    
    var description: String {
        return "photoId \(id) (album \(albumId) as image \(thumbnailUIImage != nil ? "YES" : "No") - isLoding \(isLoading ? "Yes" : "False")"
    }
}
