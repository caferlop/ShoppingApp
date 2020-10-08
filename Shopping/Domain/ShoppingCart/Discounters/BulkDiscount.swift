//
//  BulkDiscount.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public struct BulkDiscount: DiscountStrategy, Equatable {
    public var xItems: Int
    public var valueDiscount: Float
    
    public init(xItems: Int, valueDiscount: Float) {
        self.xItems = xItems
        self.valueDiscount = valueDiscount
    }
    
    public func discount(for products: [Product]) -> Float {
        if products.count >= xItems {
            var discount: Float = 0.0
            if let product = products.first {
                discount = (100 - ((valueDiscount*100)/product.price))/100
            }
            return discount
        }
        return 1.0
    }
}
