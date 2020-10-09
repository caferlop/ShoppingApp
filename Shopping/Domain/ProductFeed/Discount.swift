//
//  Discount.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public struct Discount {
    public let type: Discounts
    public let productsToApply: [Product]
    
    public init (type: Discounts, productsToApply: [Product]) {
        self.type = type
        self.productsToApply = productsToApply
    }
}
