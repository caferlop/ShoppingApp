//
//  PriceCalculator.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public protocol PriceCalculator {
    func totalPriceWithoutDiscount(for products: [Product]) -> Float
    func totalPriceWithDiscount(for products: [Product])-> Float
}
