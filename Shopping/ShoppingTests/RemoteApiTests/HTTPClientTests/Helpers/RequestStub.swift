//
//  RequestStub.swift
//  ShoppingTests
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation
import Shopping

struct RequestStub: HTTPRequest {
    var url: URL {
        return anyURL()
    }
}
