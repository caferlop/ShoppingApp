//
//  RemoteApiTests.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import XCTest
import Shopping

class RemoteProductLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestData() {
        let dummyRequest = makeRequest()
        let (_,client) = makeSUT(request: dummyRequest)
        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_load_requestData() {
        let dummyRequest = makeRequest()
        let (sut, client) = makeSUT(request: dummyRequest)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requests[0].url, [dummyRequest][0].url)
    }
    
    func test_loadTwice_requestsData() {
        let dummyRequest = makeRequest()
        let (sut, client) = makeSUT(request: dummyRequest)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual([client.requests[0].url, client.requests[1].url], [[dummyRequest][0].url,[dummyRequest][0].url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let dummyRequest = makeRequest()
        let (sut, client) = makeSUT(request: dummyRequest)
        
        expect(sut: sut, toCompleteWith: failure(error: .connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let dummyRequest = makeRequest()
        let (sut, client) = makeSUT(request: dummyRequest)
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWith: failure(error: .invalidaData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    
    func test_load_deliversErrorOn200ResponseWithInvalidaJSON() {
        let dummyRequest = makeRequest()
        let (sut, client) = makeSUT(request: dummyRequest)
        
        expect(sut: sut, toCompleteWith: failure(error: .invalidaData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliverNoItemsOn200ResponseWithEmptyJSONList() {
        let dummyRequest = makeRequest()
        let (sut, client) = makeSUT(request: dummyRequest)
        
        expect(sut: sut, toCompleteWith: .success([])) {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200ResponseWithJSONList() {
        let dummyRequest = makeRequest()
        let (sut, client) = makeSUT(request: dummyRequest)
        
        let product1 = makeItem(code: "VOUCHER", name: "voucer", price: 5)
        let product2 = makeItem(code: "TSHIRT", name: "t-shirt", price: 7.5)
        
        let products = [product1.model, product2.model]
        
        expect(sut: sut, toCompleteWith: .success(products)) {
            let json = makeItemsJSON([product1.json, product2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_notDeliverResutlOnceSutDeallocated(){
        let dummyRequest = makeRequest()
        let client = HTTPClientServiceSpy()
        
        var sut: RemoteProductLoader? = RemoteProductLoader(request: dummyRequest, client: client)
        var capturedResults = [RemoteProductLoader.Result]()
        sut?.load(completion: { capturedResults.append($0) })
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers

    private func makeSUT(request: HTTPRequest, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteProductLoader, client: HTTPClientServiceSpy) {
        let client = HTTPClientServiceSpy()
        let sut = RemoteProductLoader(request: request, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return(sut, client)
    }
    
    private func failure(error: RemoteProductLoader.Error) -> RemoteProductLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(code: String, name: String, price: Float)-> (model: Product, json: [String: Any]) {
        let item = Product(code: code, name: name, price: price)
        let json = ["code": code, "name": name, "price": price].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["products": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(sut: RemoteProductLoader, toCompleteWith expectedResult: RemoteProductLoader.Result, when action: ()-> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load to complete")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteProductLoader.Error), .failure(expectedError as RemoteProductLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }

}
