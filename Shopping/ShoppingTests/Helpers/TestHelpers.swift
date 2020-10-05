//
//  TestHelpers.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}
