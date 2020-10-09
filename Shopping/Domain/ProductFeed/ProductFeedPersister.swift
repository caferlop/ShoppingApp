//
//  ProductFeedPersister.swift
//  Shopping
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import Foundation

public protocol ProductFeedPersister {
    typealias Result = Swift.Result<Void, Error>

    func save(productFeed: [Product], completion: @escaping (Result) -> Void)
}
