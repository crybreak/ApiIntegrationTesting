//
//  ApiIntegrationTestingTests.swift
//  ApiIntegrationTestingTests
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import XCTest
import Combine

@testable import ApiIntegrationTesting

final class ApiIntegrationTestingTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    
    override  func tearDown() {
        subscriptions = []
    }
    
    func testInialAlbumsFetch() {
        let fetcher = AlbumViewModel(ressource: APIRessourcesMock())
        let promise = expectation(description: "loading albums in init")
        fetcher.$albums.sink { (albums) in
            if albums.count == 1 {
                promise.fulfill()
            }
        }.store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
    }
    
    func testErrorMessage() {
        let error = APIError.badResponse(statusCode: 404)
        let mock = APIRessourcesMock(result: .failure(error))
        let fetcher = AlbumViewModel(ressource: mock)
        let promise = expectation(description: "url fetch return error message")
        
        fetcher.$albums
        //            .filter({$0.count > 0})
            .sink { alubms in
                XCTFail("should not have album")
            }.store(in: &subscriptions)
        
        fetcher.$errorMessage
            .filter({!$0.isEmpty})
            .sink { message in
                if error.localizedDescription == message {
                    promise.fulfill()
                }
            }.store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_Fetching_Photos_For_Selected() {
        let fetcher = AlbumViewModel(ressource: APIRessourcesMock())
        let promise = expectation(description: " fetch 1 photo for select album")
        
                
        XCTAssert(fetcher.photoSelectedAlbum.count == 0, "at the begining we don't have")
        
        
        fetcher.selectedAlbum = Album(id: 1, userId: 1, title: "title")

        fetcher.$photoSelectedAlbum
            .filter({photos in
                return !photos.isEmpty
            })
            .sink { _ in
                promise.fulfill()
            }.store(in: &subscriptions)
        wait(for: [promise], timeout: 1)
    }
    
    func test_update_thumbail_Image() {
        let viewModel = AlbumViewModel(ressource: APIRessourcesMock())
        
        let initialPhoto = Photo(id: 1, albumId: 1, title: "", largeImagePath: "", thumbnailImagePath: "")
        viewModel.photoSelectedAlbum = [initialPhoto]
        
        let promise = expectation(description: " fetching image from photo")
        let promise2 = expectation(description: " photo with loading state")


        viewModel.fetchThumbnail.send(initialPhoto)
        
        viewModel.$photoSelectedAlbum
            .contains(where: { photo -> Bool in
                if let storedPhoto = photo.first(where: {$0.id == initialPhoto.id}),
                   storedPhoto.thumbnailUIImage == nil && storedPhoto.isLoading {
                    return true
                } else {return false}
            }).sink { photo in
                promise2.fulfill()
            }.store(in: &subscriptions  )
        
        viewModel.$photoSelectedAlbum
            .contains(where: { photo -> Bool in
                if let storedPhoto = photo.first(where: {$0.id == initialPhoto.id}), storedPhoto.thumbnailUIImage != nil {
                    return true
                } else {return false}
            }).sink { photo in
                promise.fulfill()
            }.store(in: &subscriptions )
        
        wait(for: [promise, promise2], timeout: 1)
    }
    
    func test_feteching_multiple_thumbnail() {
        
        let viewModel = AlbumViewModel(ressource: APIRessourcesMock())
        let firstPhoto = Photo(id: 1, albumId: 1, title: "", largeImagePath: "", thumbnailImagePath: "")
        let secondPhoto = Photo(id: 2, albumId: 1, title: "", largeImagePath: "", thumbnailImagePath: "")
        let thirdPhoto = Photo(id: 3, albumId: 1, title: "", largeImagePath: "", thumbnailImagePath: "")

        let promise = expectation(description: "fetching thumbnails exactly only once")
        let loadingExpectation = expectation(description: "photos should be first in loading state")
        viewModel.photoSelectedAlbum = [firstPhoto, secondPhoto, thirdPhoto]
        
       
        viewModel.$photoSelectedAlbum
            .dropFirst()
            .output(in: 0...2)
            .tryContains(where: {(photos) in
                try photos.allSatisfy { photo in
                    photo.thumbnailUIImage != nil && photo.isLoading
                }
            })
            
            .sink { (_) in
            } receiveValue: { result in
                loadingExpectation.fulfill()
            }.store(in: &subscriptions)

        
        viewModel.$photoSelectedAlbum
            .dropFirst()
            .print()
            .collect(3)
            .sink { photos in
                promise.fulfill()
            }.store(in: &subscriptions)
        
        viewModel.fetchThumbnail.send(firstPhoto)
        viewModel.fetchThumbnail.send(secondPhoto)
        viewModel.fetchThumbnail.send(thirdPhoto)
        viewModel.fetchThumbnail.send(firstPhoto)
        
        wait(for: [promise, loadingExpectation], timeout: 3)
        
    }
    
    func test_selecting_and_unselecting_album() {
        
    }
    
}



