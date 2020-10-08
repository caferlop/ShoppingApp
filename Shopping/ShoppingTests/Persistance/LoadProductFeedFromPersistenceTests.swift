//
//  LoadProductFeedFromPersistence.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import XCTest
import Shopping

class LoadProductFeedFromPersistenceTests: XCTestCase {
    func test_load_requestValueRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrive])
    }
    
    
    func test_load_failsOnRetreivalErro() {
        let (sut, store) = makeSUT()
        let randomError = NSError(domain: "any error", code: 0)
        
        expect(sut: sut, toCompleteWith: .failure(randomError)) {
            store.completeRetrieval(with: randomError)
        }
    }
    func test_load_returnsNoProductOnEmptyPersitence() {
        let (sut, store) = makeSUT()
        
        expect(sut: sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_load_returnsProductsOnNonEmptyPersitence() {
        let productFeed = makeFeed()
        let (sut, store) = makeSUT()
        
        expect(sut: sut, toCompleteWith: .success(productFeed.models)) {
            store.completeRetrieval(with: productFeed.local, timeStamp: Date())
        }
    }
    
//    func test_load_returnsNoValuesAfterSUTIsDeallocated() {
//        let store = ProductFeedStoreSpy()
//        var sut: LocalProductLoader? = LocalProductLoader(store: store, currentDate: Date.init)
//
//        var receivedResults = [LocalProductLoader.LoadProductResult]()
//
//        sut?.load(completion: { receivedResults.append($0) })
//
//        sut = nil
//
//        store.completeRetrievalWithEmptyCache()
//
//        XCTAssertTrue(receivedResults.isEmpty)
//    }

    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalProductLoader, store: ProductFeedStoreSpy) {
        let store = ProductFeedStoreSpy()
        let sut = LocalProductLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(sut: LocalProductLoader, toCompleteWith expectedResult: LocalProductLoader.LoadProductResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load to complete")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let(.success(receivedProducts), .success(expectedProducts)):
                XCTAssertEqual(receivedProducts, expectedProducts, file: file, line: line)
            
            case let(.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
