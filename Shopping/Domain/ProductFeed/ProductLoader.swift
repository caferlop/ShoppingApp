//
//  ProductLoader.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

public protocol ProductLoader {
    typealias Result = Swift.Result<[ProductFeed], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
