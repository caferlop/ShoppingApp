//
//  SceneDelegate.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 29/09/2020.
//

import UIKit
import Shopping
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var localStore: ProductFeedStore = {
        try! CoreDataStore( storeURL: NSPersistentContainer .defaultDirectoryURL() .appendingPathComponent("feed-store.sqlite"))
    }()
    
    private lazy var localProductLoader: LocalProductLoader = {
        LocalProductLoader(store: localStore, currentDate: Date.init)
    }()
    
    private lazy var remoteStore: HTTPClient = {
        HTTPClientService(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var remoteProductLoader: RemoteProductLoader = {
        let productRequest = ProductFeedRequest()
        return RemoteProductLoader(request: productRequest, client: remoteStore)
    }()

    func setUpScene() {
        let productLoaderDecorator = ProductLoaderPersisterDecorator(decoratee: remoteProductLoader, persister: localProductLoader)
        let productLoader = ProductLoaderWithFallBack(primary: productLoaderDecorator, fallback: localProductLoader)
        let shoppingViewController = ShoppingViewCoordinator.makeShoppingViewController(productFeedLoader: productLoader, title: "Shopping")
        window?.rootViewController = UINavigationController(rootViewController: shoppingViewController)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        setUpScene()
    }
        
}

