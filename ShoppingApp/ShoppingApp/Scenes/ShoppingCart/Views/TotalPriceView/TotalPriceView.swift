//
//  TotalPriceView.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import UIKit

@IBDesignable
class TotalPriceView: UIView {
    @IBOutlet weak var ContainerView: UIView!
    
    @IBOutlet weak var netPriceResult: UILabel!
    @IBOutlet weak var discountPriceResult: UILabel!
    @IBOutlet weak var totalResult: UILabel!
    @IBOutlet weak var checkOutButton: UIButton!
    
    var checkOut: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    @IBAction func checkOutAction(_ sender: Any) {
        checkOut()
    }
    func setupView() {
        guard let ContainerView = self.fromNib() else { fatalError("View could not load from nib") }
        addSubview(ContainerView)
        self.backgroundColor = UIColor.appColor(.primaryBackground)
        self.checkOutButton.roundCorners(corners: [.allCorners], radius: 10)
    }

}
