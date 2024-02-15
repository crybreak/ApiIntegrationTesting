//
//  AlbumListViews.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import SwiftUI

struct AlbumListViews: View {
    
    @StateObject var albumFetch = AlbumViewModel()
    
    var body: some View {
        VStack {
                List(albumFetch.albums) { album in
                    NavigationLink(
                        destination: PhotoForAlbumView(fetcher: albumFetch),
                        tag: album,
                        selection: $albumFetch.selectedAlbum,
                        label: {
                            Text(album.title)
                        })
                }
                .overlay(content: {
                    Text(albumFetch.errorMessage)
                        .foregroundStyle(Color.red)
                        .padding()
                })
                .navigationTitle("Albums")
        }
        .environmentObject(albumFetch)
    }
}

#Preview {
    NavigationStack {
        AlbumListViews()
    }
   
}
