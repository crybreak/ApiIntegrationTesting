//
//  UserViewsModel.swift
//  ApiIntegrationTesting
//
//  Created by Wilfried Mac Air on 17/02/2024.
//

import Foundation
import Combine

class UserViewsModel: ObservableObject {
    
    var addNewTodo = PassthroughSubject<Todos, Never>()
    var deleteTodo = PassthroughSubject<Todos, Never>()
    var updateTodo = PassthroughSubject<Todos, Never>()
    
    @Published var users = [User]()
    @Published var selectedUser: User? = nil
    @Published var selectedUserTodos = [Todos]()
    
    var subscriptions = Set<AnyCancellable>()
    
    let apiRessource: APIRessourcesProtocol
    
    init(ressource: APIRessourcesProtocol = APIRessources()) {
        self.apiRessource = ressource
        
        apiRessource.fetchUserPublisher()
            .replaceError(with: [User]())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("fetching users with completion \(completion)")
            } receiveValue: { users in
                self.users = users
            }.store(in: &subscriptions)
        
        $selectedUser
            .compactMap({$0})
            .removeDuplicates()
            .filter { [unowned self] user in
                return self.selectedUserTodos.first?.userId != user.id
            }
            .sink { user in
                self.selectedUserTodos = []
            }.store(in: &subscriptions)
        
        $selectedUser
            .compactMap({$0})
            .removeDuplicates()
            .map { [unowned self] user -> AnyPublisher<[Todos], Never> in
                self.apiRessource.fetchTodosPublisher(for: user.id)
                    .catch { error in
                        return Just([Todos]())
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .assign(to: &$selectedUserTodos)
    }
    
    static var preview: UserViewsModel {
        let viewModel = UserViewsModel()
        viewModel.selectedUser = User.example()
        return viewModel
    }


}
