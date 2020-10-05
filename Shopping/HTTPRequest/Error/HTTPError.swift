//
//  HTTPError.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

enum ErrorType: Error {
    case deprecated
    case generic
}

struct HTTPError {
    static func checkAPIError(response: URLResponse?, data: Data?) -> ErrorType? {
        guard response != nil && data != nil else {
            return .deprecated
        }
        
        let httpResponse = response as! HTTPURLResponse
        
        switch httpResponse.statusCode {
        case 200:
            return nil
        default:
            return .generic
        }
    }
}
