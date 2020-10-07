//
//  ProductLoader.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

public protocol ProductFeedLoader {
    typealias Result = Swift.Result<[Product], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
