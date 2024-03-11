
# Projet d'Intégration API avec Combine et Tests par Injection de Dépendances

Ce projet vise à démontrer l'intégration d'une API externe dans une application iOS en utilisant Combine pour la gestion des flux asynchrones, ainsi que les tests par injection de dépendances pour assurer la fiabilité et la maintenabilité du code.

Prérequis

Avant de commencer à utiliser ce projet, assurez-vous de disposer des éléments suivants :

Xcode 12 ou version ultérieure
Swift 5 ou version ultérieure
Une connaissance de base de Combine et des tests par injection de dépendances serait utile, mais n'est pas strictement nécessaire.
Installation

Clonez ce dépôt dans votre répertoire local.
Ouvrez le fichier .xcworkspace avec Xcode.
Configurez les variables d'environnement nécessaires dans le fichier Config.swift. Ces variables incluent l'URL de l'API et éventuellement des clés d'authentification.
Lancez l'application sur le simulateur ou un appareil iOS pour tester son fonctionnement.
Utilisation

Ce projet comprend plusieurs fonctionnalités principales :

Intégration API : La classe APIService gère les appels à l'API externe en utilisant Combine pour les requêtes asynchrones. Vous pouvez utiliser cette classe pour effectuer des appels à l'API en passant les paramètres requis et en recevant les données en retour.
Injection de Dépendances : Les dépendances nécessaires sont injectées dans les classes pertinentes pour favoriser la modularité et faciliter les tests unitaires. Les protocoles sont utilisés pour définir les interfaces, ce qui permet de remplacer facilement les implémentations lors des tests.
Tests Unitaires : Le dossier Tests comprend des tests unitaires pour valider le comportement des différentes parties de l'application. Les mocks sont utilisés pour simuler le comportement des dépendances et garantir l'isolation des tests.
Exemple d'Utilisation

Voici un exemple simplifié d'utilisation de l'API dans votre application :

swift
Copy code
// Créez une instance de l'APIService avec les dépendances nécessaires
let apiService = APIService(networkManager: NetworkManager())
```
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

