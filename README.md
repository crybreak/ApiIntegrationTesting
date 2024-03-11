
# API Integration Project with Combine and Dependency Injection Tests
This project aims to demonstrate the integration of an external API into an iOS application using Combine for asynchronous flow management, as well as dependency injection tests to ensure code reliability and maintainability.

Before starting to use this project, make sure you have the following
```

Xcode 12 or later
Swift 5 or later
Basic knowledge of Combine and dependency injection tests would be helpful but is not strictly necessary.
Installation

Clone this repository to your local directory.
bash
Copy code
Open the .xcworkspace file with Xcode.
Configure the necessary environment variables in the Config.swift file. These variables include the API URL and potentially authentication keys.
Run the application on the simulator or an iOS device to test its functionality.
```
his project includes several main features:

API Integration: The APIService class manages calls to the external API using Combine for asynchronous requests. You can use this class to make API calls by passing the required parameters and receiving data in return.

Dependency Injection: Necessary dependencies are injected into relevant classes to promote modularity and facilitate unit testing. Protocols are used to define interfaces, allowing easy replacement of implementations during testing.

Unit Tests: The Tests folder contains unit tests to validate the behavior of different parts of the application. Mocks are used to simulate dependency behavior and ensure test isolation.

swift code
 ```
// Créez une instance de 
L'APIService avec les dépendances nécessaires

  ressource.createAlbumsPublisher()
            .lane("Fetching albums")
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case.finished: break
                case.failure(let failure):
                    self.errorMessage = failure.localizedDescription
                }
            } receiveValue: { [unowned self] (albums) in
                self.albums = albums
            }.store(in: &subscriptions)
        
        //when album selected fetch corresponding
       
        $photoSelectedAlbum.sink { photos in
            print("---change photos \(photos.count) count for album \(photos.first?.albumId ?? -1)")
        }.store(in: &subscriptions
```

