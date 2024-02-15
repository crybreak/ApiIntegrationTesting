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
}



