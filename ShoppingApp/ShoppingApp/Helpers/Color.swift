//
//  Color.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 09/10/2020.
//

import UIKit

enum AssetsColor: String {
    case primaryBackground
    case secondaryBackground
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor {
        return UIColor(named: name.rawValue) ?? UIColor.clear
    }
}

