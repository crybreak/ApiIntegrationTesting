//
//  PhotoDetailView.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 15/02/2024.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    @EnvironmentObject var imageCache: ImageCashes
    var body: some View {
        VStack {
            
            Text(photo.title)
            if imageCache.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            if imageCache.selectedImage != nil {
                Image(uiImage: imageCache.selectedImage!)
                    .resizable()
                    .scaledToFit()
            }
        }.onAppear {
            imageCache.selectedPath = photo.largeImagePath
        }
    }
}

#Preview {
    PhotoDetailView(photo: Photo(id: 1, albumId: 1, title: "accusamus beatae ad facilis cum similique qui sunt", largeImagePath:  "https://via.placeholder.com/600/92c952", thumbnailImagePath: "https://via.placeholder.com/150/92c952"))
        .environmentObject(ImageCashes())
}
