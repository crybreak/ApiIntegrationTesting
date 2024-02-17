//
//  ImgaeCashes.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 15/02/2024.
//

import SwiftUI
import Foundation
import Combine

final class ImageCashes: ObservableObject {
    let fetchUIImageRequest = PassthroughSubject<String, Never>()
    var largeImageCache = NSCache<NSString, UIImage>()
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var selectedPath: String = ""
    @Published var selectedImage: UIImage? = nil
    @Published var isLoading = false
   
    init() {
        fetchUIImageRequest
            .handleEvents(receiveOutput: { [unowned self]_ in
                self.isLoading = true
                self.selectedImage = nil
            })
            .compactMap{URL(string: $0)}
            .map { url -> AnyPublisher<(String, UIImage), Never> in
                URLSession.shared.dataTaskPublisher(for: url)
                    .compactMap{(data, response) in
                        UIImage(data: data)
                    }
                    .map({ (image) in
                        return (url.path, image)
                    })
                    .receive(on: DispatchQueue.main)
                    .handleEvents(receiveCompletion: { [unowned self]_ in
                        self.isLoading = false
                    })
                    .catch({ _ in
                        Empty()
                    })
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [unowned self] (path, image) in
                self.largeImageCache.setObject(image, forKey: NSString(string: path))
                self.selectedImage = image
            }
            .store(in: &subscriptions)
        
        $selectedPath
            .receive(on: DispatchQueue.main)
            .sink { path in
                if let image = self.largeImageCache.object(forKey: NSString(string: path)) {
                    self.selectedImage = image
                } else {
                    self.fetchUIImageRequest.send(path)
                }
            }.store(in: &subscriptions)
    }
    
}
