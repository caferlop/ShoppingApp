//
//  ProductFeedStoreSpy.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import Foundation
import Shopping

class ProductFeedStoreSpy: ProductFeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedProducts
        case insert([LocalProductItem], Date)
        case retrive
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrieveCompletion]()
    
    func deletePersistedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedProducts)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    func insert(feed: [LocalProductItem], timeStamp timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    func retrieve(completion: @escaping RetrieveCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrive)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success(.none))
    }
    
    func completeRetrieval(with feed: [LocalProductItem], timeStamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.success(ProductFeedCache(feed: feed, timeStamp: timeStamp)))
    }
}
