//
//  ShoppingCartTests.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import XCTest
import Shopping

class ShoppingCartTests: XCTestCase {
    func test_AddOneVoucherProduct() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        expect(sut: sut,product: voucher ,toAddProduct: (netPrice: 5, discountedPrice: 5))
    }
    
    func test_AddTwoVoucherProducts() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        expecTwice(sut: sut, product: voucher)
    }
    
    func test_AddThreeVoucherProducts() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        expecTrice(sut: sut, product: voucher)
    }
    
    func test_RemoveVoucherProductAfterAddingThreeProducts() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        expecTrice(sut: sut, product: voucher)
        expect(sut: sut, product: voucher, toRemoveProduc: (netPrice: 10, discountedPrice: 5))
    }
    
    func test_ResultChallengeExample1() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 5, discountedPrice: 5))
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-shirt", price: 20)
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 25, discountedPrice: 25))
        let mug = Product(code: "MUG", name: "Cabify Mug", price: 7.5)
        expect(sut: sut, product: mug, toAddProduct: (netPrice: 32.5, discountedPrice: 32.5))
    }
    
    func test_ResultChallengeExample2() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 5, discountedPrice: 5))
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-shirt", price: 20)
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 25, discountedPrice: 25))
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 30, discountedPrice: 25))
    }
    
    func test_ResultChallengeExample3() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-shirt", price: 20)
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 20, discountedPrice: 20))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 40, discountedPrice: 40))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 60, discountedPrice: 57))
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 65, discountedPrice: 62))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 85, discountedPrice: 81))
    }
    
    func test_ResultChallengeExample4() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-shirt", price: 20)
        let mug = Product(code: "MUG", name: "Cabify Mug", price: 7.5)
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 5, discountedPrice: 5))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 25, discountedPrice: 25))
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 30, discountedPrice: 25))
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 35, discountedPrice: 30))
        expect(sut: sut, product: mug, toAddProduct: (netPrice: 42.5, discountedPrice: 37.5))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 62.5, discountedPrice: 57.5))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 82.5, discountedPrice: 74.5))
    }
    
    func test_RemoveTShirtToResultChallengeExample4() {
        let sut = makeSUT()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-shirt", price: 20)
        let mug = Product(code: "MUG", name: "Cabify Mug", price: 7.5)
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 5, discountedPrice: 5))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 25, discountedPrice: 25))
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 30, discountedPrice: 25))
        expect(sut: sut, product: voucher, toAddProduct: (netPrice: 35, discountedPrice: 30))
        expect(sut: sut, product: mug, toAddProduct: (netPrice: 42.5, discountedPrice: 37.5))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 62.5, discountedPrice: 57.5))
        expect(sut: sut, product: tshirt, toAddProduct: (netPrice: 82.5, discountedPrice: 74.5))
        expect(sut: sut, product: tshirt, toRemoveProduc: (netPrice: 62.5, discountedPrice: 57.5))
    }

    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> ShoppingCart {
        let calculator = makePriceCalculator()
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-shirt", price: 20)
        let mug = Product(code: "MUG", name: "Cabify Mug", price: 7.5)
        let sut = ShoppingCartManager(calculator: calculator, productsAvailable: [voucher, tshirt, mug])
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private func expecTwice(sut: ShoppingCart, product: Product ,file: StaticString = #file, line: UInt = #line) {
        expect(sut: sut,product: product ,toAddProduct: (netPrice: 5, discountedPrice: 5))
        expect(sut: sut,product: product ,toAddProduct: (netPrice: 10, discountedPrice: 5))
    }
    
    private func expecTrice(sut: ShoppingCart, product: Product ,file: StaticString = #file, line: UInt = #line) {
        expect(sut: sut,product: product ,toAddProduct: (netPrice: 5, discountedPrice: 5))
        expect(sut: sut,product: product ,toAddProduct: (netPrice: 10, discountedPrice: 5))
        expect(sut: sut,product: product ,toAddProduct: (netPrice: 15, discountedPrice: 10))
    }
    
    private func expect(sut: ShoppingCart, product: Product, toAddProduct expectedResult: ShoppingCart.TransactionResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Add product transactio fullfiled")
        
        sut.addProduct(product: product) { (ShoppingCartTransaction) in
            XCTAssertEqual(expectedResult.netPrice, ShoppingCartTransaction.netPrice)
            XCTAssertEqual(expectedResult.discountedPrice, ShoppingCartTransaction.discountedPrice)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    private func expect(sut: ShoppingCart, product: Product, toRemoveProduc expectedResult: ShoppingCart.TransactionResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Remove product fullfiled")
        
        sut.removeProduct(product: product) { (ShoppingCartTransaction) in
            XCTAssertEqual(expectedResult.netPrice, ShoppingCartTransaction.netPrice)
            XCTAssertEqual(expectedResult.discountedPrice, ShoppingCartTransaction.discountedPrice)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    

}
