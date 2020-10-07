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

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    @discardableResult
    func sendRequest(request: HTTPRequest, completion: @escaping(Result) -> Void) -> HTTPClientTask
}

public class HTTPClientService {
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

extension HTTPClientService: HTTPClient {
    public func sendRequest(request: HTTPRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let newRequest = request.asUrlRequest()
        let task = session.dataTask(with: newRequest) { data, response, error in
            completion(Result {
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


