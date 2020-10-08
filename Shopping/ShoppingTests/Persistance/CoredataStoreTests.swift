//
//  CoredataStoreTests.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import XCTest
import Shopping

class CoredataStoreTests: XCTestCase {
    func test_retreiveNoValueWhenPersistenceEmpty() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_retrieveValueWhenPersistenceNoEmpty() {
        let sut = makeSUT()
        let feedOfProducts = makeFeed().local
        let timeStamp = Date()
        
        insert(cache: (feed: feedOfProducts, timeStamp: timeStamp), to: sut)
        
        expect(sut, toRetrieve: .success(ProductFeedCache(feed:feedOfProducts, timeStamp: timeStamp)))
    }
    
    func test_insertThrowNoErrorsWhenPersistenceEmpty() {
        let sut = makeSUT()
        let feedOfProducts = makeFeed().local
        let insertionError = insert(cache: (feed: feedOfProducts, timeStamp: Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to successfuylly persist insertion")
    }
    
    func test_insertThrowsNoErrorsWhenPersistenceNoEmpty() {
        let sut = makeSUT()
        let feedOfProducts = makeFeed().local
        insert(cache: (feed: feedOfProducts, timeStamp: Date()), to: sut)
        let insertionError = insert(cache: (feed: feedOfProducts, timeStamp: Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override persistence successfully")
    }
    
    func test_insertOverridesPreviouslyInsertedValue() {
        let sut = makeSUT()
        insert(cache: (feed: makeFeed().local, timeStamp: Date()), to: sut)
        
        let latestFeed = makeFeed().local
        let latestTimeStamp = Date()
        
        insert(cache: (feed: latestFeed, timeStamp: latestTimeStamp), to:  sut)
        
        expect(sut, toRetrieve: .success(ProductFeedCache(feed: latestFeed, timeStamp: latestTimeStamp)))
    }
    
    func test_deleteThrowsNoErrorsWhenPersistenceEmpty() {
        let sut = makeSUT()
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected to success deletion when persistance has no values")
    }
    
    func test_deleteThrowsNoErrorWhenPersistanceNotEmpty() {
        let sut = makeSUT()
        insert(cache: (feed: makeFeed().local, timeStamp: Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected to succeed deletion when peristance has values")
    }
    
    func test_deleteDeletesPreviewsPersistedValue() {
        let sut = makeSUT()
        insert(cache: (feed: makeFeed().local, timeStamp: Date()), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_operationsInPersitenceRunsSerially()  {
        let sut = makeSUT()
        
        var orderedOperations = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(feed: makeFeed().local, timeStamp: Date()) { _ in
            orderedOperations.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deletePersistedFeed { _ in
            orderedOperations.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(feed: makeFeed().local, timeStamp: Date()) { _ in
            orderedOperations.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(orderedOperations, [op1,op2,op3], "Operations run in the wrong order")
    }
    
    // MARK: - Helpers
    
    @discardableResult
    func insert(cache: (feed: [LocalProductItem], timeStamp: Date), to sut: ProductFeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(feed: cache.feed, timeStamp: cache.timeStamp) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: ProductFeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deletePersistedFeed { result in
            if case let Result.failure(error) = result { deletionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }


    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> ProductFeedStore {
        let storeBundle = Bundle(for: CoreDataStore.self)
        let storeULR = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataStore(storeURL: storeULR, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: ProductFeedStore, toRetrieve expectedResult: ProductFeedStore.RetrieveResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                 (.failure, .failure):
                break
                
            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timeStamp, expected.timeStamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
