//
//  ApiIntegrationTestingApp.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 14/02/2024.
//

import SwiftUI

@main
struct ApiIntegrationTestingApp: App {
    @StateObject var imageCaches = ImageCashes()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageCaches)
        }
    }
}
