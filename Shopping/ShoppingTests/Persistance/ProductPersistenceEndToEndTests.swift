//
//  ProductPersistenceEndToEndTests.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import XCTest
import Shopping

class ProductPersistenceEndToEndTests: XCTestCase {

    override func setUpWithError() throws {
        setupEmptyStoreState()
    }

    override func tearDownWithError() throws {
        undoStoreSideEffects()
    }
    
    func test_loadReturnsNoProductsOnEmptyPersistence() {
        let sut = makeSUT()
        
        expect(sut: sut, toLoad: [])
    }
    
    func test_loadReturnsProductsSavedInADifferenteInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = makeFeed().models
        
        save(feed: feed, with: sutToPerformSave)

        expect(sut: sutToPerformLoad, toLoad: feed)
    }
    
    func test_saveOverridesItemsSavedInADifferentInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformLastSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstFeed = makeFeed().models
        let latestFeed = makeFeed().models
        
        save(feed: firstFeed, with: sutToPerformFirstSave)
        save(feed: latestFeed, with: sutToPerformLastSave)

        expect(sut: sutToPerformLoad, toLoad: latestFeed)
    }

    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalProductLoader {
        let storeBundle = Bundle(for: CoreDataStore.self)
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalProductLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func save(feed: [ProductFeed], with loader: LocalProductLoader, file: StaticString = #file, line: UInt = #line) {
        let saveExp = expectation(description: "Wait for save completion")
        loader.save(productFeed: feed) { result in
            if case let Result.failure(error) = result {
                XCTAssertNil(error, "Expected to save feed successfully", file: file, line: line)
            }
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
    }
    
    private func expect(sut: LocalProductLoader, toLoad expectedFeed: [ProductFeed], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(loadedFeed):
                XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }


}
