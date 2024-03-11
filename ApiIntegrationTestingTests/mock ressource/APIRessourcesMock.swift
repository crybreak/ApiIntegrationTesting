//
//  APIRessourcesMock.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation
import Combine
import SwiftUI

struct APIRessourcesMock: APIRessourcesProtocol {
    
    
    
    var result: Result<[Album], APIError> = .success([Album(id: 1, userId: 1, title: "dummy album")])
    var photosResult: Result<[Photo], APIError> = .success([Photo(id: 1, albumId: 1, title: "title", largeImagePath:  "url", thumbnailImagePath:  "url")])
    var TodoResult: Result<[Todos], APIError> = .success([Todos(id: 1, userId: 1, title: "dummmy", completed: true)])
    var userResult:  Result<[User], APIError> = .success([User.example()])
    func createAlbumsPublisher() -> AnyPublisher<[Album], APIError> {
//        let album = Album(id: 1, userId: 1, title: "dummy album")
//        
//        return Just([album])
//            .setFailureType(to: APIError.self)
//            .eraseToAnyPublisher()
        
        return result.publisher
            .eraseToAnyPublisher()
    }
    
    func fetchPhotosWithQuery(searchKey: APIRessources.SearchKey, searchId: Int) -> AnyPublisher<[Photo], APIError> {
        return photosResult.publisher
            .eraseToAnyPublisher()  
    }
    
    func fetechImage(for photo: Photo) -> AnyPublisher<Photo, Never> {
        let image = UIImage(systemName: "plus")
        var copy = photo
        copy.thumbnailUIImage = image
        return Just(copy)
            .eraseToAnyPublisher()
    }

    func fetchTodosPublisher(for userId: Int) -> AnyPublisher<[Todos], APIError> {
        return TodoResult.publisher
            .eraseToAnyPublisher()
    }
    
    func fetchUserPublisher() -> AnyPublisher<[User], APIError> {
        return userResult.publisher
            .eraseToAnyPublisher()
    }
}
