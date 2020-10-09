//
//  ProductTableViewCell.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    private var quantity: Int = 0
    private var productCode: String = ""
    
    var add: (String) -> Void = {_ in}
    var remove: (String) -> Void = {_ in}
    
    @IBAction func addAction(_ sender: Any) {
        self.add(productCode)
        quantity += 1
        quantityLabel.text = String(quantity)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        self.remove(productCode)
        if quantity > 0 {
            quantity -= 1
            quantityLabel.text = String(quantity)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.discountLabel.rotate(degrees: -45)
        self.removeButton.roundCorners(corners: [.allCorners], radius: 5)
        self.addButton.roundCorners(corners: [.allCorners], radius: 5)
        self.selectionStyle = .none
    }

    func configureCell(for product: ProductDataModel) {
        productCode = product.code
        productName.text = product.name
        productPrice.text = product.price.localizedCurrency
        discountLabel.textColor = UIColor.green
        guard let discountType = product.discountType else {
            discountLabel.text = ""
            return
        }
        discountLabel.text = discountType
    }
}
