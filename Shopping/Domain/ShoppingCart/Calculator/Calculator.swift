//
//  Calculator.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public struct Calculator: PriceCalculator {
    
    private let discountDispatcher: DiscountStrategyDispatcher
    
    public init(discountDispatcher: DiscountStrategyDispatcher) {
        self.discountDispatcher = discountDispatcher
    }
    
    public func totalPriceWithoutDiscount(for products: [Product]) -> Float {
        return products.map { $0.price }.reduce(0, +)
    }
    
    public func totalPriceWithDiscount(for products: [Product]) -> Float {
        let discountTotalPrice = products.map { $0.price * (self.discountDispatcher.applyDiscountStrategy(for: $0)).discount(for: products)}.reduce(0, +)
        
        return discountTotalPrice
    }
    
}
