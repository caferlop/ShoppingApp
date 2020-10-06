//
//  RemoteProductFeed.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

public struct RemoteProductItem: Decodable, Equatable {
    public let code: String
    public let name: String
    public let price: Float
    
    public init(code: String, name: String, price: Float) {
        self.code = code
        self.name = name
        self.price = price
    }
}


