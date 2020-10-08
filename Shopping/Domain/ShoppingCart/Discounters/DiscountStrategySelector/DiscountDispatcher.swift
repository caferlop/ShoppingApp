//
//  DiscountDispatcher.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public struct DiscountDispatcher: DiscountStrategyDispatcher {
    private let discountsAvailable: [Discount]
    
    public init (discountsAvailable: [Discount]) {
        self.discountsAvailable = discountsAvailable
    }
    
    public func applyDiscountStrategy(for product: Product) -> DiscountStrategy {
        let discounts = getDiscountStrategy(for: product)
        switch discounts {
        case .buyXGetY:
            return BuyXGetYDiscount(xItems: 2)
        case .bulk:
            return BulkDiscount(xItems: 3, valueDiscount: 1)
        case .none:
            return NoDiscount()
            
        }
    }
    
    private func getDiscountStrategy(for product: Product) -> Discounts {
        var discountType: Discounts = .none
        self.discountsAvailable.forEach {
            if ($0.productsToApply.first { $0.code == product.code } != nil) {
                discountType = $0.type
            }
        }
        return discountType
    }
}
