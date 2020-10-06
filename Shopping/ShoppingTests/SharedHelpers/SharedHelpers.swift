//
//  SharedHelpers.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import XCTest
import Shopping

extension XCTest {
    func makeRequest(file: StaticString = #file, line: UInt = #line) -> HTTPRequest {
        let dummyRequest = RequestStub()
        return dummyRequest
    }
}
