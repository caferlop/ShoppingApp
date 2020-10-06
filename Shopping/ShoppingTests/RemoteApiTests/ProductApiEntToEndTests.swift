//
//  ProductApiEntToEndTests.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import XCTest
import Shopping

class ProductApiEntToEndTests: XCTestCase {
    
    //    "products": [
    //        {
    //          "code": "VOUCHER",
    //          "name": "Cabify Voucher",
    //          "price": 5
    //        },
    //        {
    //          "code": "TSHIRT",
    //          "name": "Cabify T-Shirt",
    //          "price": 20
    //        },
    //        {
    //          "code": "MUG",
    //          "name": "Cabify Coffee Mug",
    //          "price": 7.5
    //        }
    //      ]

    func test_endToEnd() {
        let voucher = ProductFeed(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        let tshirt = ProductFeed(code: "TSHIRT", name: "Cabify T-Shirt", price: 20)
        let mug = ProductFeed(code: "MUG", name: "Cabify Coffee Mug", price: 7.5)
        switch getProductFeedResult() {
        case let .success(products)?:
            XCTAssertEqual(products.count, 3, "Got 3 products as expected")
            XCTAssertEqual(products[0], voucher)
            XCTAssertEqual(products[1], tshirt)
            XCTAssertEqual(products[2], mug)
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    private func getProductFeedResult(file: StaticString = #file, line: UInt = #line) -> ProductLoader.Result? {
        let request = ProductFeedRequest()
        let client = HTTPClientService(session: URLSession(configuration: .ephemeral))
        
        let productLoader = RemoteProductLoader(request: request, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(productLoader, file: file, line: line)
        
        let exp = expectation(description: "Wait for products to load")
        
        var receivedResult: ProductLoader.Result?
        productLoader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        
        return receivedResult
    }

}