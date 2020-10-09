//
//  ShoppingCartManager.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public final class ShoppingCartManager: ShoppingCart {
    public var priceCalculator: PriceCalculator {
        return calculator
    }
    private let calculator: PriceCalculator
    private var productList = [Product]()
    private var availableProducts: [Product]
    public var productsAvailable: [Product] {
        get {
            return availableProducts
        }
        set {
            availableProducts = newValue
        }
    }
    
    public init (calculator: PriceCalculator, productsAvailable: [Product]) {
        self.calculator = calculator
        self.availableProducts = productsAvailable
    }
    
    public func addProduct(product: Product, completion: @escaping (TransactionResult) -> Void)  {
        productList.append(product)
        processTransaction(for: product){ transaction in
            completion(transaction)
        }
    }
    
    public func removeProduct(product: Product, completion: @escaping (TransactionResult) -> Void) {
        if let index = productList.firstIndex(of: product) {
            productList.remove(at: index)
        }
        processTransaction(for: product){ transaction in
            completion(transaction)
        }
    }
    
    private func processTransaction(for product: Product, completion: @escaping (TransactionResult) -> Void) {
        let processQueue = DispatchQueue(label: "com.caferlop.shoppingApp.queue", attributes: [.concurrent])
        
        var productMatrix = [[Product]]()
        processQueue.async(qos: .userInteractive, flags: .barrier) {
            productMatrix = self.productSorter(product: product)
        }
        
        var totalNetPrice: Float = 0.0
        processQueue.async(qos: .userInteractive, flags: .barrier) {
            totalNetPrice = self.totalPriceWithoutDiscount(for: productMatrix)
        }
        
        var totalDiscountedPrice: Float = 0.0
        processQueue.async(qos: .userInteractive, flags: .barrier) {
            totalDiscountedPrice = self.totalPriceWithDiscount(for: productMatrix)
            let discount = totalNetPrice - totalDiscountedPrice
            completion ((netPrice:totalNetPrice, discountedPrice: totalDiscountedPrice, discount: discount))
        }
    }
    
    private func totalPriceWithoutDiscount(for matrixOfProduct: [[Product]]) -> Float {
        var priceList = [Float]()
        matrixOfProduct.forEach { products in
            let netPriceForKindOfProduct = self.calculator.totalPriceWithoutDiscount(for: products)
            priceList.append(netPriceForKindOfProduct)
        }
        let totalNetPrice = priceList.reduce(0, +)
        return totalNetPrice
    }
    
    private func totalPriceWithDiscount(for matrixOfProduct: [[Product]]) -> Float {
        var priceList = [Float]()
        matrixOfProduct.forEach { products in
            let discountedPriceForKindOfProduct = self.calculator.totalPriceWithDiscount(for: products)
            priceList.append(discountedPriceForKindOfProduct)
        }
        let totalDiscountedPrice = priceList.reduce(0, +)
        return totalDiscountedPrice
    }
    
    private func productSorter(product: Product)-> [[Product]] {
        var matrixOfProducts = [[Product]]()
        availableProducts.forEach { productStocked in
            var productsSorted = [Product]()
            productList.forEach { product in
                if productStocked.code == product.code {
                    productsSorted.append(product)
                }
            }
            matrixOfProducts.append(productsSorted)
        }
        return matrixOfProducts
    }
}
