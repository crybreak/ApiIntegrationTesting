//
//  UserDetailView.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 17/02/2024.
//

import SwiftUI

struct UserDetailView: View {
    @ObservedObject var userModel: UserViewsModel
    @State private var showOnlyUnCompleted: Bool = false

    var filteredTodos: [Todos] {
        if showOnlyUnCompleted {
            let todos = userModel.selectedUserTodos.filter({$0.completed == true})
            return todos
        } else {
            return userModel.selectedUserTodos
        }
    }
    var body: some View {
        
        VStack (alignment: .leading) {
            HStack {
                Spacer()
                Text(showOnlyUnCompleted ?  "only uncompleted" : "show all")
                    .font(.headline)
                Toggle(isOn: $showOnlyUnCompleted.animation(), label: {
                    Text("")
                }).labelsHidden()
            }
            .padding([.horizontal, .top])
            
            List {
                ForEach(filteredTodos) { todo in
                    HStack {
                        Text("\(todo.id)")
                        Image(systemName: todo.completed ? "checkmark.circle" : "circle")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                var comp = todo
                                comp.completed = true
                            }
                        
                        Text(todo.title)
                    }
                }
            }
            .navigationBarTitle(Text(userModel.selectedUser?.username ?? ""), displayMode: .inline)
        }
    }
}

#Preview {
    UserDetailView(userModel: UserViewsModel.preview)
        .environmentObject(UserViewsModel())
}
