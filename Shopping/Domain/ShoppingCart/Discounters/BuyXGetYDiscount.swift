//
//  BuyXGetYDiscount.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public struct BuyXGetYDiscount: DiscountStrategy, Equatable {
    public var xItems: Int
    
    public init(xItems: Int) {
        self.xItems = xItems
    }
    
    public func discount(for products: [Product]) -> Float {
        if products.count >= xItems {
            let count = products.count
            let numberOfItemsToPayFor = Float(count)-Float(floor(Double(count/xItems)))
            let discount = numberOfItemsToPayFor/Float(count)
            return discount
        }
        return 1
    }
}
