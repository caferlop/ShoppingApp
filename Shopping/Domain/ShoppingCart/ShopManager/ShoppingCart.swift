//
//  ShoppingCart.swift
//  Shopping
//
//  Created by Carlos Fernandez on 07/10/2020.
//

import Foundation

public protocol ShoppingCart {
    typealias TransactionResult = (netPrice: Float, discountedPrice: Float, discount: Float)
    var productsAvailable: [Product] { get set }
    func addProduct(product: Product, completion: @escaping (TransactionResult) -> Void)
    func removeProduct(product: Product, completion: @escaping (TransactionResult) -> Void)
}
