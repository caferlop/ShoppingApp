//
//  LocalProductLoadewr.swift
//  Shopping
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import Foundation

public final class LocalProductLoader: ProductLoader {
    
    private let store: ProductFeedStore
    private let currentDate: () -> Date
    
    public init(store: ProductFeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public typealias LoadProductResult = ProductLoader.Result
    
    public func load(completion: @escaping (LoadProductResult) -> Void) {
        
        store.retrieve { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            
            case let .success(.some(cache)):
                completion(.success(cache.feed.toModels()))
                
            case .success(.none):
                completion(.success([]))
            }
        }
        
    }
}

extension LocalProductLoader {
    public typealias SaveResult = Result<Void, Error>
    
    public func save(productFeed: [Product], completion : @escaping (SaveResult) -> Void) {
        store.deletePersistedFeed { [weak self] deletionResult in
            guard self != nil else { return }
             
            switch deletionResult {
            case .success:
                self?.persist(feed: productFeed, with: completion)
                
            case let .failure(error):
                completion(.failure(error))
            }
            
        }
    }
    
    private func persist(feed: [Product], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed: feed.toLocal(), timeStamp: currentDate()) { [weak self] insertionResult in
            guard self != nil else { return }
            completion(insertionResult)
        }
    }
}

private extension Array where Element == Product {
    func toLocal() -> [LocalProductItem] {
        return map { LocalProductItem(code: $0.code, name: $0.name, price: $0.price) }
    }
}

private extension Array where Element == LocalProductItem {
    func toModels() -> [Product] {
        return map { Product(code: $0.code, name: $0.name, price: $0.price)  }
    }
}
