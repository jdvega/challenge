//
//  UIViewExtensions.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/26/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

extension UIView {
    //MARK: View Border on Axis
    public enum HorizontalBorderType {
        case top
        case bottom
        
        func primaryAnchor(view: UIView) -> NSLayoutYAxisAnchor {
            switch self {
            case .top:
                return view.topAnchor
            case .bottom:
                return view.bottomAnchor
            }
        }
    }
    public enum VerticalBorderType {
        case left
        case right
        
        func primaryAnchor(view: UIView) -> NSLayoutXAxisAnchor {
            switch self {
            case .left:
                return view.leftAnchor
            case .right:
                return view.rightAnchor
            }
        }
    }
    
    func applyHorizontalBorder(type: HorizontalBorderType, color: UIColor = UIColor.black) {
        let horizontalBorder = self.constraintView(color: color)
        self.addSubview(horizontalBorder)
        horizontalBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        type.primaryAnchor(view: horizontalBorder).constraint(equalTo: type.primaryAnchor(view: self)).isActive = true
        horizontalBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        horizontalBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
    }
    
    func applyVerticalBorder(type: VerticalBorderType, color: UIColor = UIColor.black) {
        let verticalBorder = self.constraintView(color: color)
        self.addSubview(verticalBorder)
        verticalBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        type.primaryAnchor(view: verticalBorder).constraint(equalTo: type.primaryAnchor(view: self)).isActive = true
        verticalBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        verticalBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    func constraintView(color: UIColor = UIColor.black) -> UIView {
        let constraintView = UIView(frame: CGRect.zero)
        constraintView.backgroundColor = color
        constraintView.translatesAutoresizingMaskIntoConstraints = false
        return constraintView
    }
    
    
    //MARK: Corner Radius with Layer
    func applyCornerRadius(borderColor: CGColor? = nil) {
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor
            self.layer.borderWidth = 2.0
        }
        
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
        
    }
}

