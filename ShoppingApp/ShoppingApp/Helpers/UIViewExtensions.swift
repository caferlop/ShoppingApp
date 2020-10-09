//
//  UIViewExtensions.swift
//  ShoppingApp
//
//  Created by Carlos Fernandez on 08/10/2020.
//

import UIKit

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self))
            .loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        return contentView
    }
    
    func setGradientBackgroundColor(frame: CGRect? = nil ,colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        if let externalframe = frame {
            gradientLayer.frame = externalframe
        } else {
            gradientLayer.frame = bounds
        }
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
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
    
    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }

    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}

extension UITableView {
    func registerCell(for identifier: String) {
        let nib = UINib.init(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}

