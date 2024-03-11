//
//  APIRessourcesProtocol.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation
import Combine

protocol APIRessourcesProtocol {
    
    func createAlbumsPublisher() -> AnyPublisher<[Album], APIError>
    func fetchPhotosWithQuery(searchKey: APIRessources.SearchKey , searchId: Int) -> AnyPublisher<[Photo], APIError>
    func fetechImage(for photo: Photo) -> AnyPublisher<Photo, Never> 
    func fetchUserPublisher() -> AnyPublisher<[User], APIError> 
    func fetchTodosPublisher(for userId: Int) -> AnyPublisher<[Todos], APIError>
}
