//
//  HTTPClientServiceSpy.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import Foundation
import Shopping

class HTTPClientServiceSpy: HTTPClient {
    private var messages = [(request: HTTPRequest, completion: (HTTPClient.Result) -> Void)]()
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    var requests: [HTTPRequest] {
        return messages.map { $0.request }
    }
    
    private struct TaskSpy: HTTPClientTask {
        let cancelCallBack: () -> Void
        func cancel() {
            cancelCallBack()
        }
    }
    
    private(set) var cancelledRequests = [HTTPRequest]()
    
    func sendRequest(request: HTTPRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((request, completion))
        return TaskSpy { [weak self] in self?.cancelledRequests.append(request)}
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requests[index].url,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}
