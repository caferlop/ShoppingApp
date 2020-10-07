//
//  CoreDataStore.swift
//  Shopping
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import Foundation
import CoreData

public final class CoreDataStore {
    private static let modelName = "FeedStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        guard let model = CoreDataStore.model else {
            throw StoreError.modelNotFound
        }
        do {
            container = try NSPersistentContainer.load(name: CoreDataStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform {
            action(context)
        }
    }
    
    private func cleanUpReferencesToPersistenStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistenStores()
    }
}

extension CoreDataStore: ProductFeedStore {
    public func retrieve(completion: @escaping RetrieveCompletion) {
        perform { context in
            completion(Result {
                try ManagedProductFeed.find(in: context).map {
                    ProductFeedCache(feed: $0.localFeed, timeStamp: $0.timeStamp)
                }
            })
        }
    }
    
    public func deletePersistedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedProductFeed.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(feed: [LocalProductItem], timeStamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedProductFeed.newUniqueInstance(in: context)
                managedCache.timeStamp = timeStamp
                managedCache.feed = ManagedProductItem.products(from: feed, in: context)
                try context.save()
            })
        }
    }
}
