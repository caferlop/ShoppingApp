//
//  ShoppingViewController.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import UIKit
import Combine

final class ShoppingViewController: UIViewController {
    var viewModel: ShoppingCartViewModel?
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet fileprivate weak var shoppingCartView: TotalPriceView!
    @IBOutlet weak var productListStateView: ProductListStateView!
    @IBOutlet weak var productsTableView: ProductsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productsTableView.setUpTableView()
        self.view.setGradientBackgroundColor(
            colorTop: UIColor.appColor(.primaryBackground),
            colorBottom: UIColor.appColor(.secondaryBackground)
        )
        setUpBindings()
        setUpActions()
        self.viewModel?.loadProducts()
    }
    
    private func setUpBindings() {
        guard let safeViewModel = self.viewModel else { return }
        
        safeViewModel.discountedPricePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] discount in
                self?.shoppingCartView.discountPriceResult.text = "Discount price: " + discount.setFormmaterForEmptyString
            }.store(in: &subscriptions)
        
        safeViewModel.totalPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] total in
                self?.shoppingCartView.totalResult.text = "Total price: " + total.setFormmaterForEmptyString
            }.store(in: &subscriptions)
        
        safeViewModel.netPricePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] net in
                self?.shoppingCartView.netPriceResult.text = "Net price: " + net.setFormmaterForEmptyString
            }.store(in: &subscriptions)
        
        safeViewModel.productFeedPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] products in
                self?.hideErrorView()
                self?.productsTableView.products = products
        }.store(in: &subscriptions)
        
        safeViewModel.errorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.showErrorView(with: error)
            }.store(in: &subscriptions)
    }
    
    
    
    private func showErrorView(with error: String) {
        productListStateView.showErrorView(with: error)
        productsTableView.isHidden = true
    }
    
    private func hideErrorView() {
        productListStateView.isHidden = true
        productsTableView.isHidden = false
    }
    
    private func setUpActions(){
        productsTableView.addAction = { [weak self] code in
            self?.viewModel?.addProduct(code: code)
        }
        productsTableView.removeAction = { [weak self] code in
            self?.viewModel?.removeProduct(code: code)
        }
        productsTableView.reloadAction = { [weak self] in
            self?.viewModel?.loadProducts()
        }
        productListStateView.reloadAction = { [weak self] in
            self?.hideErrorView()
            self?.viewModel?.loadProducts()
        }
        
        shoppingCartView.checkOut = { [weak self] in
            self?.shoppingCartView.netPriceResult.text = "Net price: " + Float(0).localizedCurrency
            self?.shoppingCartView.totalResult.text = "Total price: " + Float(0).localizedCurrency
            self?.shoppingCartView.discountPriceResult.text = "Discount price: " + Float(0).localizedCurrency
            self?.viewModel?.loadProducts()
        }
    }
    
    
    
}
