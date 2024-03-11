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
    
    static func url(with endpoint: EndPoint, id: Int? = nil) -> URL? {
        if let id = id {
            return urlComponenents.url?.appendingPathComponent(endpoint.rawValue)
                .appendingPathComponent(String(id))
        } else {
            return urlComponenents.url?.appendingPathComponent(endpoint.rawValue)
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
        fetchPublisher(type: [Album].self, endPoint: .albums)
    }
    
   
    func fetchPhotosWithQuery(searchKey: SearchKey , searchId: Int) -> AnyPublisher<[Photo], APIError> {
        fetchPublisher(type: [Photo].self, endPoint: .photos, searchKey: searchKey, id: searchId)
    }
    
    func fetechImage(for photo: Photo) -> AnyPublisher<Photo, Never> {
        if let url = URL(string: photo.thumbnailImagePath) {
            return fetchUrl(url: url)
                    .compactMap{ ( data) in
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
    
    enum HttpMethod: String {
        case POST, PUT, PATCH, DELETE
    }
    
    //TODO: mock this
    func fetchUserPublisher() -> AnyPublisher<[User], APIError> {
        fetchPublisher(type: [User].self, endPoint: .users)
    }
    
    //TODO: mock this
    func fetchTodosPublisher(for userId: Int) -> AnyPublisher<[Todos], APIError> {
        fetchPublisher(type: [Todos].self, endPoint: .todos, searchKey: .userId, id: userId)
    }
    
    //MARK: Compose requests
    
    static func createRequest(endPoint: EndPoint, id: Int? = nil, httpMethod: HttpMethod, data: Data? = nil) -> URLRequest?  {
        guard let url = APIRessources.url(with: endPoint, id: id) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let data = data {
            request.httpBody = data
        }

        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        return request
    }
    
    func postRequestForTodoPublisher(request: URLRequest) -> AnyPublisher<Todos, APIError> {
        return postRequestPublisher(request: request)
            .decode(type: Todos.self, decoder: JSONDecoder())
            .mapError({APIError.convert(error: $0)})
            .eraseToAnyPublisher()
    }
    
    
    
    private func postRequestPublisher(request: URLRequest) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                    return data
                } else {
                    throw APIError.badURL
                }
            }
            .eraseToAnyPublisher()
    }
    
    func updatePublihser(todo: Todos) -> AnyPublisher<Todos, APIError>{
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(todo),
           let request = APIRessources.createRequest(endPoint: .todos, id: todo.id, httpMethod: .PUT, data: data) {
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data: Data, response: URLResponse) in
                    if let response = response as? HTTPURLResponse,
                       !(200...299).contains(response.statusCode) {
                        throw APIError.badResponse(statusCode: response.statusCode)
                    } else {
                        return data
                    }
                })
                .decode(type: Todos.self, decoder: JSONDecoder())
                .mapError({APIError.convert(error: $0)})
                .eraseToAnyPublisher()
        } else {
           return  Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
    }
     func deletePublisher(todo: Todos) -> AnyPublisher<Todos, APIError> {
        if let request = APIRessources.createRequest(endPoint: .todos, id: todo.id, httpMethod: .DELETE) {
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ (data: Data, response: URLResponse) in
                    if let response = response as? HTTPURLResponse,
                       !(200...299).contains(response.statusCode) {
                        throw APIError.badResponse(statusCode: response.statusCode)
                    } else {
                        return data
                    }
                })
                .decode(type: Todos.self, decoder: JSONDecoder())
                .mapError({APIError.convert(error: $0)})
                .eraseToAnyPublisher()
        } else {
           return  Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
    }
    
   
}

extension APIRessources {
    
    private func fetchPublisher<T>(type: T.Type, endPoint: EndPoint) -> AnyPublisher<T, APIError> where T: Decodable {
        if let url = APIRessources.url(with: endPoint) {
            return fetchUrl(url: url)
                .decode(type: type, decoder: JSONDecoder())
                .mapError({APIError.convert(error: $0)})
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
    }
    
    private func fetchPublisher<T>(type: T.Type, endPoint: EndPoint, searchKey: SearchKey, id: Int) -> AnyPublisher<T, APIError> where T: Decodable {
        if let url = APIRessources.urlWithQuery(for: endPoint, searchKey: searchKey, searchId: id) {
            return fetchUrl(url: url)
                .decode(type: type, decoder: JSONDecoder())
                .mapError({APIError.convert(error: $0)})
                .eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.badURL)
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
