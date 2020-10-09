//
//  ProductDataModel.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 09/10/2020.
//

import Foundation

public struct ProductDataModel: Equatable, Hashable {
    public let code: String
    public let name: String
    public let price: Float
    public var discountType: String?
    
    public init(code: String, name: String, price: Float, discountType: String?) {
        self.code = code
        self.name = name
        self.price = price
        self.discountType = discountType
    }
}
