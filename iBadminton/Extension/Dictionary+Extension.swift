//
//  Dictionary+Extension.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/4.
//

import Foundation
import UIKit

extension Array where Element == Int {
    
    func averageRating() -> Double {
        
        let count: Double = Double(self.count)
        
        var totalValue: Double = 0
        
        self.forEach {
            totalValue += Double($0)
        }
        
        return Double(totalValue / count).rounding(toDecimal: 1)
    }
    
}
// 四捨五入
extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigits = pow(10.0, Double(decimal))
        return (self * numberOfDigits).rounded(.toNearestOrAwayFromZero) / numberOfDigits
    }
}
