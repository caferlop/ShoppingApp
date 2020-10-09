//
//  ShoppingViewModel.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import Foundation
import Shopping
import Combine

protocol ShoppingCartViewModelOutPut {
    var productFeedPublisher: Published<[ProductDataModel]>.Publisher { get }
    var netPricePublisher: Published<String>.Publisher { get }
    var discountedPricePublisher: Published<String>.Publisher { get }
    var totalPublisher: Published<String>.Publisher { get }
    var errorPublisher: Published<String>.Publisher { get }
    func loadProducts()
}

protocol ShoppingCartViewModelInPut {
    func addProduct(code: String)
    func removeProduct(code: String)
}

typealias ShoppingCartViewModel = ShoppingCartViewModelInPut & ShoppingCartViewModelOutPut

final class ShoppingViewModel: ShoppingCartViewModel {
    private let productStore: ProductFeedLoader
    private var shoppingCart: ShoppingCart
    private var discountsList: [Discount]
    
    @Published private var productFeed: [ProductDataModel] = [ProductDataModel]()
    @Published private var error: String = ""
    @Published private var netPrice: String = ""
    @Published private var discount: String = ""
    @Published private var total: String = ""
    
    var productFeedPublisher: Published<[ProductDataModel]>.Publisher { $productFeed }
    var netPricePublisher: Published<String>.Publisher { $netPrice }
    var discountedPricePublisher: Published<String>.Publisher { $discount }
    var totalPublisher: Published<String>.Publisher { $total }
    var errorPublisher: Published<String>.Publisher { $error }
    
    init (productStore: ProductFeedLoader, shoppingCart: ShoppingCart, discountsAvailable:[Discount]) {
        self.productStore = productStore
        self.shoppingCart = shoppingCart
        self.discountsList = discountsAvailable
    }
    
    func addProduct(code: String) {
        guard let product = makeProduct(code: code) else { return }
        self.shoppingCart.addProduct(product: product) { [weak self] (netPrice, discountedPrice, discount) in
            self?.getAmountsToPublish(netPrice: netPrice, discountedPrice: discountedPrice, discount: discount)
        }
    }
    
    func removeProduct(code: String) {
        guard let product = makeProduct(code: code) else { return }
        self.shoppingCart.removeProduct(product: product) { [weak self] (netPrice, discountedPrice, discount) in
            self?.getAmountsToPublish(netPrice: netPrice, discountedPrice: discountedPrice, discount: discount)
        }
    }
    
    private func getAmountsToPublish(netPrice: Float, discountedPrice: Float, discount: Float) {
        DispatchQueue.main.async {
            self.netPrice = netPrice.localizedCurrency
            self.total = discountedPrice.localizedCurrency
            self.discount = discount.localizedCurrency
        }
    }
    
    func loadProducts() {
        self.productStore.load { [weak self] result in
            switch result {
            case let .success(products):
                self?.productFeed = self?.productsToProductsDataModel(products: products) ?? [ProductDataModel]()
                self?.shoppingCart.productsAvailable = products
            case let .failure(error):
                self?.error = error.localizedDescription
            }
        }
    }
    
    private func makeProduct(code: String) -> Product? {
        return self.productFeed.toModels().first { $0.code == code }
    }
    
    private func productsToProductsDataModel(products: [Product]) -> [ProductDataModel] {
        var productsDataModel = [ProductDataModel]()
        products.forEach {
            let type = getDiscountLabel(for: $0)
            let model = ProductDataModel(code: $0.code, name: $0.name, price: $0.price, discountType: type)
            productsDataModel.append(model)
        }
        return productsDataModel
    }
    
    private func getDiscountStrategy(for product: Product) -> Discounts {
       var discountType: Discounts = .none
       self.discountsList.forEach {
           if ($0.productsToApply.first { $0.code == product.code } != nil) {
               discountType = $0.type
           }
       }
       return discountType
   }
    
    private func getDiscountLabel(for product: Product) -> String? {
        let discounts = getDiscountStrategy(for: product)
        switch discounts {
        case .buyXGetY:
            return "2x1"
        case .bulk:
            return "3+"
        case .none:
            return nil
        }
    }
}

private extension Array where Element == ProductDataModel {
    func toModels() -> [Product] {
        return map { Product(code: $0.code, name: $0.name, price: $0.price)  }
    }
}
