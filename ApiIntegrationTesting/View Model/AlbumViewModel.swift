//
//  AlbumViewModel.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import Foundation
import Combine
import SwiftUI
import TimelaneCombine

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
            .lane("Fetching albums")
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
       
        $photoSelectedAlbum.sink { photos in
            print("---change photos \(photos.count) count for album \(photos.first?.albumId ?? -1)")
        }.store(in: &subscriptions
        )
//        $selectedAlbum
//            .compactMap({$0})
//            .removeDuplicates()
//            .lane ("reset photo")
//            .sink { _ in
//                self.photoSelectedAlbum = []
//            }.store(in: &subscriptions)
        
        $selectedAlbum
            .lane("selecting album", transformValue: { album in
                return "albumId \(album?.id ?? -1)"
            })
            .compactMap{$0}
            .removeDuplicates()
            .handleEvents(receiveOutput: { [unowned self] (_) in
                self.photoSelectedAlbum = []
            })
            .map { [unowned self] (album) -> AnyPublisher<[Photo], Never> in
                return self.apiRessource
                    .fetchPhotosWithQuery(searchKey: .albumId, searchId: album.id)
                    .receive(on: DispatchQueue.main)
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
            .print("update photos 👉")
            .lane("fetching photos selected", filter: .event, transformValue: { photos in
                return "updating \(photos.count) photo for albumId \(photos.first?.albumId ?? -1)"
            })
            .assign(to: &$photoSelectedAlbum)
        
        
        fetchThumbnail
            .lane("thumbnail fetch")
            .filter({$0.thumbnailUIImage == nil})
            .filter({ [unowned self] photo in
                if let stored = self.photoSelectedAlbum.first(where: {$0.id == photo.id}) {
                    return !stored.isLoading
                } else {
                    return false
                }
            })
            .handleEvents(receiveOutput: { [unowned self] photo in
                if let index = self.photoSelectedAlbum.firstIndex(where: {$0.id == photo.id}) {
                    self.photoSelectedAlbum[index].isLoading = true
                }
            })
            .lane("thumnail filter")
            .flatMap({ [unowned self] (photo) -> AnyPublisher<Photo, Never>  in
                self.apiRessource.fetechImage(for: photo)
            })
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] photo in
                if let index = self.photoSelectedAlbum.firstIndex(where: {$0.id == photo.id}) {
                    self.photoSelectedAlbum[index] = photo
                   
                }
            }.store(in: &subscriptions)

        
    }
    
    static var preview: AlbumViewModel {
        let viewModel = AlbumViewModel()
        viewModel.selectedAlbum = Album(id: 1, userId: 1, title: "dummy album")
        return viewModel
    }
}
