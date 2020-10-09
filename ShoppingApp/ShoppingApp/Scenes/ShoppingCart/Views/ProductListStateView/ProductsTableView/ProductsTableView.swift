//
//  ProductsTableView.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import UIKit

@IBDesignable
class ProductsTableView: UITableView {
    private var productsDataSource: UITableViewDiffableDataSource<Section,ProductDataModel>!
    private var productCell: ProductTableViewCell?
    private let refresher = UIRefreshControl()
   
    var addAction: (String) -> Void = { _ in }
    var removeAction: (String) -> Void = { _ in }
    var reloadAction: () -> Void = {}
    
    var products: [ProductDataModel]? {
        didSet {
            guard let safeProducts = products else { return }
            setSnapShot(from: safeProducts)
        }
    }
    
    func setUpTableView(){
        self.registerCell(for: ProductTableViewCell.className)
        setUpRefresher()
        self.backgroundColor = UIColor.clear
        self.tableFooterView = UIView()
        self.tableFooterView?.isHidden = true
        setUpProductsDataSource()
    }
    
    private func setUpRefresher(){
        self.refreshControl = refresher
        self.refresher.addTarget(self, action: #selector(reload), for: .valueChanged)
    }
    
    @objc private func reload(){
        reloadAction()
    }
    
    private func reactToCellActions() {
        self.productCell?.add = { [weak self] code in
            self?.addAction(code)
        }
        self.productCell?.remove = { [weak self] code in
            self?.removeAction(code)
        }
    }
    
    private func setUpProductsDataSource() {
        productsDataSource = UITableViewDiffableDataSource<Section, ProductDataModel>(tableView: self, cellProvider: { (tableView, indexPath, product) -> UITableViewCell? in
            self.productCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.className, for: indexPath) as? ProductTableViewCell
            self.productCell?.configureCell(for: product)
            self.reactToCellActions()
            return self.productCell
        })
    }
    
    private func setSnapShot(from products: [ProductDataModel]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDataModel>()
            snapshot.appendSections([.main])
            snapshot.appendItems(products)
            
            self.productsDataSource.apply(snapshot, animatingDifferences: true)
            self.refresher.endRefreshing()
        }
    }
}

extension ProductsTableView {
    fileprivate enum Section: Hashable {
        case main
    }
}
