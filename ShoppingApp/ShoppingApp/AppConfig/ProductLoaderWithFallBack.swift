//
//  ProductLoaderWithFallBack.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import Shopping

public class ProductLoaderWithFallBack: ProductFeedLoader {
    private let primary: ProductFeedLoader
    private let fallback: ProductFeedLoader
    
    public init(primary: ProductFeedLoader, fallback: ProductFeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    public func load(completion: @escaping (ProductFeedLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}
