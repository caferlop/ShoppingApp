//
//  DiscountDispatcherTests.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import XCTest
import Shopping

class DiscountDispatcherTests: XCTestCase {
    func test_DiscountMatchProducts() {
        let sut = makeDiscountDispatcher()
        
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        XCTAssertEqual( BuyXGetYDiscount(xItems: 2), sut.applyDiscountStrategy(for: voucher) as! BuyXGetYDiscount)
        
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-Shirt", price: 20)
        XCTAssertEqual( BulkDiscount(xItems: 3, valueDiscount: 1), sut.applyDiscountStrategy(for: tshirt) as! BulkDiscount)
        
        let mug = Product(code: "MUG", name: "Cabify Mug", price: 20)
        XCTAssertEqual( NoDiscount(), sut.applyDiscountStrategy(for: mug) as! NoDiscount)
    }
}
