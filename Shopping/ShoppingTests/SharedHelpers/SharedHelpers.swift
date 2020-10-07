//
//  SharedHelpers.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import XCTest
import Shopping

extension XCTest {
    func makeRequest(file: StaticString = #file, line: UInt = #line) -> HTTPRequest {
        let dummyRequest = RequestStub()
        return dummyRequest
    }
    
    func makeFeed()-> (models: [Product], local: [LocalProductItem])  {
        let productFeed1 = Product(code: "VOUCHER", name: "Cabify voucher", price: 10)
        let productFeed2 = Product(code: "T-SHIRT", name: "Cabify T-Shirt", price: 5)
        let models = [productFeed1, productFeed2]
        let locals = models.map { LocalProductItem(code: $0.code, name: $0.name, price: $0.price) }
        return (models, locals)
    }
}
