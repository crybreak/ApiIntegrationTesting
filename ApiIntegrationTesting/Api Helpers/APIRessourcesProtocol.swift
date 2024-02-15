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
}