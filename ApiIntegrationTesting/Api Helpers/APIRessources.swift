//
//  APIRessources.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation
import Combine
import SwiftUI

struct APIRessources: APIRessourcesProtocol {
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
    
    private func fetchUrl(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
           .tryMap({ (data, response) in
               if  let respone = response as? HTTPURLResponse,
                   !(200...299).contains(respone.statusCode) {
                   throw APIError.badResponse(statusCode: respone.statusCode)
               } else {
                   return data
               }
           }).eraseToAnyPublisher()
    }
    
    func createAlbumsPublisher() -> AnyPublisher<[Album], APIError> {
        if let url = APIRessources.url(with: .albums) {
           
            return fetchUrl(url: url)
                 .decode(type: [Album].self, decoder: JSONDecoder())
                 .mapError({ APIError.convert(error: $0)})
                 .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchPhotosWithQuery(searchKey: SearchKey , searchId: Int) -> AnyPublisher<[Photo], APIError> {
        if let url = APIRessources.urlWithQuery(for: .photos, searchKey: .albumId, searchId: searchId) {
            return fetchUrl(url: url)
                .decode(type: [Photo].self, decoder: JSONDecoder())
                .mapError {APIError.convert(error: $0)}
                .eraseToAnyPublisher()
        } else {
           return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
    }
    
    func fetechImage(for photo: Photo) -> AnyPublisher<Photo, Never> {
        if let url = URL(string: photo.thumbnailImagePath) {
            return URLSession.shared.dataTaskPublisher(for: url)
                    .compactMap{ ( data, response) in
                         UIImage(data: data)
                    }
                    .map { image -> Photo in
                        var photo = photo
                        photo.thumbnailUIImage = image
                        return photo
                    }
                    .replaceError(with: photo)
                    .eraseToAnyPublisher()
        } else {
            return Just(photo)
                .eraseToAnyPublisher()
        }
    }
}


extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
    }
}
