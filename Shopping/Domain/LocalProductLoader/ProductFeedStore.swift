//
//  ProductFeedStore.swift
//  Shopping
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import Foundation

public typealias ProductFeedCache = (feed: [LocalProductItem], timeStamp: Date)

public protocol ProductFeedStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrieveResult = Result<ProductFeedCache?, Error>
    typealias RetrieveCompletion = (RetrieveResult) -> Void
    
    
    func deletePersistedFeed(completion: @escaping DeletionCompletion)
    
    func insert(feed: [LocalProductItem], timeStamp: Date, completion: @escaping InsertionCompletion)
    
    func retrieve(completion: @escaping RetrieveCompletion)
}
