//
//  ProductListStateView.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 09/10/2020.
//

import UIKit

@IBDesignable
class ProductListStateView: UIView {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var reloadAction: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        guard let containerView = self.fromNib() else { fatalError("View could not load from nib") }
        addSubview(containerView)
        self.actionButton.roundCorners(corners: [.allCorners], radius: 10)
        self.spinner.startAnimating()
    }
    
    func showErrorView(with error: String) {
        self.isHidden = false
        self.errorLabel.text = error
        self.actionButton.isHidden = error.count == 0 ? true : false
        self.errorLabel.isHidden = error.count == 0 ? true : false
        self.spinner.isHidden = error.count == 0 ? false : true
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        reloadAction()
    }
}
