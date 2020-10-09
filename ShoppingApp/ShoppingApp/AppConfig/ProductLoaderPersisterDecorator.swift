//
//  ProductLoaderPersisterDecorator.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import Foundation
import Shopping

public final class ProductLoaderPersisterDecorator: ProductFeedLoader {
    private let decoratee: ProductFeedLoader
    private let persister: ProductFeedPersister
    
    public init(decoratee: ProductFeedLoader, persister: ProductFeedPersister) {
        self.decoratee = decoratee
        self.persister = persister
    }
    
    public func load(completion: @escaping (ProductFeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.persister.saveIgnoringResult(productFeed: feed)
                return feed
            })
        }
    }
}

private extension ProductFeedPersister {
    func saveIgnoringResult(productFeed: [Product]) {
        save(productFeed: productFeed) { _ in }
    }
}

