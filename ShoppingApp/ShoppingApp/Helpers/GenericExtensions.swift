//
//  GenericExtensions.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import Foundation

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}

public extension Float {
    var stringValue: String {
        return String(format: "%.2f", self)
    }
}

public extension Float {
    var localizedCurrency: String {
        let currencyFormatter = CacheNumberFormatter.sharedInstance.numberFormatter
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        return currencyFormatter.string(from: NSNumber(value: self))!
    }
}

class CacheNumberFormatter {
    static let sharedInstance = CacheNumberFormatter()
    let numberFormatter = NumberFormatter()
}

public extension String {
    var setFormmaterForEmptyString: String {
        return self.count == 0 ? Float(0.0).localizedCurrency : self
    }
}
