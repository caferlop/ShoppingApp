//
//  RemoteProductLoader.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

public final class RemoteProductLoader: ProductFeedLoader {
    
    private let request: HTTPRequest
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidaData
    }
    
    public typealias Result = ProductFeedLoader.Result
    
    public init(request: HTTPRequest, client: HTTPClient) {
        self.request = request
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.sendRequest(request: request) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteProductLoader.map(data: data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try RemoteProductMapper.map(data: data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteProductItem {
    func toModels() -> [Product] {
        return map { Product(code: $0.code, name: $0.name, price: $0.price) }
    }
}
