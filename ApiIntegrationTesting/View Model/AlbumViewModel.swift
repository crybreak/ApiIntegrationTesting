//
//  AlbumViewModel.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation
import Combine
import SwiftUI

class AlbumViewModel: ObservableObject {
    
    @Published var albums = [Album]()

    @Published var selectedAlbum: Album? = nil
    
    @Published var errorMessage: String = ""
    @Published var errorPhotoMessage: String = ""
    @Published var photoSelectedAlbum = [Photo]()
    
    let fetchThumbnail = PassthroughSubject<Photo, Never >()
    
    var subscriptions = Set<AnyCancellable>()
    
    let apiRessource: APIRessourcesProtocol
    
    init(ressource: APIRessourcesProtocol = APIRessources()) {
        //fetch all albums
        self.apiRessource = ressource
        
        ressource.createAlbumsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case.finished: break
                case.failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            } receiveValue: { [unowned self] (albums) in
                self.albums = albums
            }.store(in: &subscriptions)
        
        //when album selected fetch corresponding
       
        $selectedAlbum
            .compactMap{$0}
            .map { [unowned self] (album) -> AnyPublisher<[Photo], Never> in
                return self.apiRessource
                    .fetchPhotosWithQuery(searchKey: .albumId, searchId: album.id)
                    .handleEvents(receiveCompletion: { completion in
                        switch completion {
                        case .finished: break
                        case .failure(let error):
                            self.errorPhotoMessage = error.localizedDescription
                        }
                    })
                    .replaceError(with: [Photo]())
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .assign(to: &$photoSelectedAlbum)
        
        fetchThumbnail
            .flatMap { photo -> AnyPublisher<Photo, Never> in
                if let url = URL(string: photo.thumbnailImagePath) {
                    URLSession.shared.dataTaskPublisher(for: url)
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
                    Just(photo)
                        .eraseToAnyPublisher()
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in
                <#code#>
            } receiveValue: { <#Publishers.ReceiveOn<Publishers.FlatMap<AnyPublisher<Photo, Never>, PassthroughSubject<Photo, Never>>, DispatchQueue>.Output#> in
                <#code#>
            }

        
    }
    
    static var preview: AlbumViewModel {
        let viewModel = AlbumViewModel()
        viewModel.selectedAlbum = Album(id: 1, userId: 1, title: "dummy album")
        return viewModel
    }
}
