//
//  DiscountStrategyDispatcher.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public protocol DiscountStrategyDispatcher {
    func applyDiscountStrategy(for product: Product) -> DiscountStrategy
}
