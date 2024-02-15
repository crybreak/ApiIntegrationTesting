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
            Text(photo.title)
        }.navigationTitle(fetcher.selectedAlbum?.title ?? "")
    }
}

#Preview {
   
    return NavigationStack {
        PhotoForAlbumView(fetcher: AlbumViewModel.preview)
    }
}
