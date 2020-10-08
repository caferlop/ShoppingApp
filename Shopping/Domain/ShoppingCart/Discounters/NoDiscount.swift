//
//  NoDiscount.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public struct NoDiscount: DiscountStrategy, Equatable {
    public init() {}
    
    public func discount(for products: [Product]) -> Float {
        return 1.0
    }
}
