//
//  UIColorExtension.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/15.
//

import Foundation
import UIKit

enum MXColor: String {
    
    case mainBlue = "MainBlue"
    case blue = "Blue"
    case lightBlue = "LightBlue"
    case yellow = "Yellow"
}

extension UIColor {
    
    static func maxColor(with bColor: MXColor) -> UIColor {
        
        guard let color = UIColor(named: bColor.rawValue) else { return UIColor() }
        
        return color
    }
}

extension CALayer {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    let maskPath = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))

    let shape = CAShapeLayer()
    shape.path = maskPath.cgPath
    mask = shape
  }
}
