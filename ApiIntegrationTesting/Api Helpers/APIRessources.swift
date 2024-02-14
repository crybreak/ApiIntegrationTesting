//
//  APIRessources.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation

struct APIRessources {
    enum EndPoint: String {
        case post, users, comments, albums, photos, todos
    }
    
    enum SearchKey: String {
        case albumId, userId, postId
    }
    
    static var urlComponenents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        return urlComponents
    }
    
    static func url(with endpoint: EndPoint) -> URL? {
        if let url = urlComponenents.url {
            return url.appendingPathComponent(endpoint.rawValue)
        } else {
            return nil
        }
    }
    
    static func urlWithQuery(for endpoint: EndPoint, searchKey: SearchKey, searchId: Int) -> URL?  {
        var componts = urlComponenents
        componts.path = "/" + endpoint.rawValue
        componts.setQueryItems(with: [searchKey.rawValue : String(searchId)])
        
        return componts.url
    }
}


extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
    }
}
