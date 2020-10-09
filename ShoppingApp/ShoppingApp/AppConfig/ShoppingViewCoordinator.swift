//
//  ShoppingViewCoordinator.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import Foundation
import UIKit
import Shopping
import CoreData

public final class ShoppingViewCoordinator {
    private init(){}
    
    static func makeShoppingViewController(productFeedLoader: ProductFeedLoader, title: String) -> ShoppingViewController {
        let viewModel = makeViewModel(productFeedLoader: productFeedLoader)
        let bundle = Bundle(for: ShoppingViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let shoppingViewController = storyboard.instantiateInitialViewController() as! ShoppingViewController
        shoppingViewController.title = title
        shoppingViewController.viewModel = viewModel
        return shoppingViewController
    }
    
    private static func makeViewModel(productFeedLoader: ProductFeedLoader) -> ShoppingCartViewModel {
        let shoppingCart = makeShoppingCartEngine(productsAvailable: [])
        let discounts = makeDiscounts()
        let shoppingViewModel = ShoppingViewModel(productStore: productFeedLoader, shoppingCart: shoppingCart, discountsAvailable: discounts)
        return shoppingViewModel
    }
    
    private static func makeShoppingCartEngine(productsAvailable: [Product]) -> ShoppingCart {
        let discountDispatcher = makeDiscountDispatcher()
        let calculator = Calculator(discountDispatcher: discountDispatcher)
        let shoppingCart = ShoppingCartManager(calculator: calculator, productsAvailable: [])
        return shoppingCart
    }
    
    private static func makeDiscountDispatcher() -> DiscountStrategyDispatcher {
        let discounts = makeDiscounts()
        return DiscountDispatcher(discountsAvailable: discounts )
    }
    
    private static func makeDiscounts() -> [Discount] {
        let voucher = Product(code: "VOUCHER", name: "Cabify Voucher", price: 5)
        let tshirt = Product(code: "TSHIRT", name: "Cabify T-Shirt", price: 20)
        let mug = Product(code: "MUG", name: "Cabify Mug", price: 7.5)
        
        let discount1 = Discount(type: .buyXGetY, productsToApply: [voucher])
        let discount2 = Discount(type: .bulk, productsToApply: [tshirt])
        let discount3 = Discount(type: .none, productsToApply: [mug])
        
        return [discount1, discount2, discount3]
    }
}
