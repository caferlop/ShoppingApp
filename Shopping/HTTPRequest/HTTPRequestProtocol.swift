//
//  HTTPRequestProtocol.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

public protocol HTTPRequest {
    var headers: [String: String] { get }
    var method: String { get }
    var url: URL { get }
    var parameters: [String: Any]? { get }
}

extension HTTPRequest {

    public func asUrlRequest()  -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method
        urlRequest.allHTTPHeaderFields = self.headers
        if let requestParamenters = parameters  {
            let data = try? JSONSerialization.data(withJSONObject: requestParamenters, options: [])
            urlRequest.httpBody = data
        }
        return urlRequest
    }

    public var headers: [String: String] {
        return [:]
    }

    public var method: String {
        return "GET"
    }

    public var parameters: [String: Any]? {
        return nil
    }

}
