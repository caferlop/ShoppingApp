//
//  PriceCalculatorTests.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import XCTest
import Shopping

class PriceCalculatorTests: XCTestCase {
    func test_netPriceForProductList() {
        let sut = makePriceCalculator()
        let voucherList = makeListOfVoucher()
        
        let totalPrice = sut.totalPriceWithoutDiscount(for: voucherList)
        XCTAssertEqual(15, totalPrice)
    }
    
    func test_totalDiscountPriceForVoucherProductListBuyXGetY() {
        let sut = makePriceCalculator()
        let voucherList = makeListOfVoucher()
        
        let totalDiscountedPrice = sut.totalPriceWithDiscount(for: voucherList)
        XCTAssertEqual(10, totalDiscountedPrice)
    }
    
    func test_totalDiscountPriceForTShirtProductListBulk() {
        let sut = makePriceCalculator()
        let tshirtList = makeListOfTShirts()
        
        let totalDiscountedPrice = sut.totalPriceWithDiscount(for: tshirtList)
        XCTAssertEqual(76, totalDiscountedPrice)
    }
    
    func test_noDiscountOnMugsSorry() {
        let sut = makePriceCalculator()
        let mugList = makeListOfMugs()
        
        let totalDiscountedPrice = sut.totalPriceWithDiscount(for: mugList)
        XCTAssertEqual(15, totalDiscountedPrice)
    }

    //MARK: - Helpers
    
    private func makeListOfVoucher() -> [Product] {
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        return [voucher, voucher, voucher]
    }
    
    private func makeListOfTShirts() -> [Product] {
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-Shirt", price: 20)
        return [tshirt,tshirt,tshirt,tshirt]
    }
    
    private func makeListOfMugs() -> [Product] {
        let mug = Product(code: "MUG", name: "Cabify Mug", price: 7.5)
        return [mug, mug]
    }
}
