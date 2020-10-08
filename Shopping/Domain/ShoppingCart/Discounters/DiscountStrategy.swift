//
//  DiscountStrategy.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public enum Discounts {
    case buyXGetY
    case bulk
    case none
}

public protocol DiscountStrategy {
    func discount(for products: [Product]) -> Float
}


