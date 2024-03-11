//
//  UsersListView.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 17/02/2024.
//

import SwiftUI

struct UsersListView: View {
    @StateObject var userModel =  UserViewsModel()
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                Text("Show tasks for your group").font(.title2)
                    .padding()
                List(userModel.users) { user in
                    NavigationLink(
                        destination: UserDetailView(userModel: userModel),
                        tag: user,
                        selection: $userModel.selectedUser,
                        label: {
                            HStack  {
                                Text(user.username)
                                Spacer()
                                Text(user.email)
                                    .font(.footnote)
                            }
                        }
                        )
                }
                .navigationTitle("User")
            .environmentObject(userModel)
            }
           
        }
    }
}

#Preview {
    NavigationStack {
        UsersListView()
    }
}
