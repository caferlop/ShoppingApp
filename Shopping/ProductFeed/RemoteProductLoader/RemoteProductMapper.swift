//
//  RemoteProductMapper.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

final class RemoteProductMapper {
        
    private struct Root: Decodable {
        let products: [RemoteProductItem]
    }
    
    private static var OK_200: Int { return 200 }
    
    static func map(data: Data, from response: HTTPURLResponse) throws -> [RemoteProductItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteProductLoader.Error.invalidaData
        }
        return root.products
    }
}
