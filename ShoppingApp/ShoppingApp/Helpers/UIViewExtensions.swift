//
//  UIViewExtensions.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func addSubviewWithConstraints(attributes: [NSLayoutConstraint.Attribute], parentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        parentView.insertSubview(self, aboveSubview: parentView)
        
        for attribute in attributes {
            parentView.addConstraint(NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .equal,
                toItem: parentView,
                attribute: attribute,
                multiplier: 1.0,
                constant: 0.0)
            )
        }
    }
    
    func setGradientBackgroundColor(colorTop: UIColor, colorBottom: UIColor, cornerRadius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius

        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addShadow(color: CGColor, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

