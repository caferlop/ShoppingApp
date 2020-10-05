//
//  HTTPClientProtocol.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClientProtocol{
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    @discardableResult
    func sendRequest(request: HTTPRequest, completionHandler: @escaping(Result) -> Void) -> HTTPClientTask
}

class HTTPClient {
    private let session: URLSession
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
}

extension HTTPClient: HTTPClientProtocol {
    func sendRequest(request: HTTPRequest, completionHandler: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let newRequest = request.asUrlRequest()
        let task = session.dataTask(with: newRequest) { data, response, error in
            completionHandler(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
    

    
}


