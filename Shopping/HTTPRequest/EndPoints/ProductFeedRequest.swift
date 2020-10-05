//
//  ProductFeedRequest.swift
//  Shopping
//
//  Created by Carlos Fernandez on 05/10/2020.
//

import Foundation

struct ProductFeedRequest {}

extension ProductFeedRequest: HTTPRequest {
    var url: URL {
        return URL(staticString: "https://gist.githubusercontent.com/palcalde/6c19259bd32dd6aafa327fa557859c2f/raw/ba51779474a150ee4367cda4f4ffacdcca479887/Products.json")
    }
    
    var method: String {
        return "GET"
    }
}
