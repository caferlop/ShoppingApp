//
//  DiscounterTests.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import XCTest
import Shopping

class DiscounterTests: XCTestCase {
    // Asumming Discounts can apply at one kind of product at a time.
    // Asumming products listed are all the same kind.
    
    func test_BuyXGetYDiscountOnEmptyProductList() {
        let sut = makeSUT(with: .buyXGetY, itemsForDiscount: 1)
    
        let expectedDiscount = Float(1.0)
        XCTAssertEqual(expectedDiscount, sut.discount(for: []))
    }
    
    func test_BuyXGetYDiscountForOneItemWithNotEmptyProductList() {
        let sut = makeSUT(with: .buyXGetY, itemsForDiscount: 2)
        let product = Product(code: "Voucher", name: "Cabify voucher", price: 10)
        
        let expectedDiscount = Float(1.0)
        XCTAssertEqual(expectedDiscount, sut.discount(for: [product]))
    }
    
    func test_BuyXGetYDiscountForQualifiedDiscountProductList() {
        let sut = makeSUT(with: .buyXGetY, itemsForDiscount: 2)
        let product = Product(code: "Voucher", name: "Cabify voucher", price: 10)
        
        let expectedDiscount = Float(0.5)
        XCTAssertEqual(expectedDiscount, sut.discount(for: [product, product]))
    }
    
    func test_BuyXGetYDiscountForQualifiedDiscountTwoTimesProductList() {
        let sut = makeSUT(with: .buyXGetY, itemsForDiscount: 2)
        let product = Product(code: "Voucher", name: "Cabify voucher", price: 10)
        
        let expectedDiscount = Float(0.5)
        XCTAssertEqual(expectedDiscount, sut.discount(for: [product, product, product, product]))
    }
    
    func test_BuyXGetYDiscountForQualifiedProductListWithEvenNumber() {
        let sut = makeSUT(with: .buyXGetY, itemsForDiscount: 2)
        let product = Product(code: "Voucher", name: "Cabify voucher", price: 10)
        
        let expectedDiscount = Float(0.6666667)
        XCTAssertEqual(expectedDiscount, sut.discount(for: [product, product, product]))
    }
    
    func test_BulkDiscountOnEmptyProductList() {
        let sut = makeSUT(with: .bulk, itemsForDiscount: 3, valueToDiscount: 1)
        let expectedDiscount = Float(1.0)
        
        XCTAssertEqual(expectedDiscount, sut.discount(for: []))
    }
    
    func test_BulkDiscountOnOneItemProductList() {
        let sut = makeSUT(with: .bulk, itemsForDiscount: 3, valueToDiscount: 1)
        let expectedDiscount = Float(1.0)
        let product = Product(code: "Voucher", name: "Cabify voucher", price: 10)
        
        XCTAssertEqual(expectedDiscount, sut.discount(for: [product]))
    }
    
    func test_BulkDiscountForQualifiedProductList() {
        let sut = makeSUT(with: .bulk, itemsForDiscount: 3, valueToDiscount: 1)
        let expectedDiscount = Float(0.9)
        let product = Product(code: "Voucher", name: "Cabify voucher", price: 10)
        
        XCTAssertEqual(expectedDiscount, sut.discount(for: [product, product, product, product]))
    }
    
    func test_NoDiscounOnEmptyProductList() {
        let sut = makeSUT(with: .none)
        let expectedDiscount = Float(1)
        
        XCTAssertEqual(expectedDiscount, sut.discount(for: []))
    }
    
    func test_NoDiscounOnNotEmptyProductList() {
        let sut = makeSUT(with: .none)
        let expectedDiscount = Float(1)
        let product = Product(code: "Voucher", name: "Cabify voucher", price: 10)
        
        XCTAssertEqual(expectedDiscount, sut.discount(for: [product, product, product, product]))
    }
    // MARK: - Helpers
    
    private func makeSUT(with discountType: Discounts, itemsForDiscount: Int? = nil, valueToDiscount: Float? = nil, file: StaticString = #file, line: UInt = #line) -> DiscountStrategy {
        switch discountType {
        case .buyXGetY:
            return BuyXGetYDiscount(xItems: itemsForDiscount!)
        case .bulk:
            return BulkDiscount(xItems: itemsForDiscount!, valueDiscount: valueToDiscount!)
        case .none:
            return NoDiscount()
        }
    }

}
