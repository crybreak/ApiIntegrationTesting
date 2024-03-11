//
//  PhotoForAlbumView.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import SwiftUI

struct PhotoForAlbumView: View {
    @ObservedObject var fetcher: AlbumViewModel
    
    var body: some View {
        List(fetcher.photoSelectedAlbum) {photo in
            NavigationLink(destination: {
                PhotoDetailView(photo: photo)
            }, label: {
                HStack {
                    if let photoImage = photo.thumbnailUIImage {
                        Image(uiImage: photoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .center)
                    } else {
                        ZStack {
                            Color.gray.opacity(0.2)
                                .frame(width: 100, height: 100, alignment: .center)
                            if photo.isLoading {
                                ProgressView()
                            }
                        }
                        
                    }
                    Text(photo.title)
                }
                .onAppear {
                    fetcher.fetchThumbnail.send(photo)
                }
            })
        }.navigationTitle("\(fetcher.selectedAlbum?.id ?? 0)")
    }
}

#Preview {
   
    return NavigationStack {
        PhotoForAlbumView(fetcher: AlbumViewModel.preview)
    }
}
