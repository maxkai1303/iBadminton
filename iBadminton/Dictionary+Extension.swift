//
//  Dictionary+Extension.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/4.
//

import Foundation
import UIKit

extension Dictionary where Key == String, Value == Int {
    
    typealias TeamRate = [String: Int]
    
    func averageRating() -> Double {
        var count: CGFloat = 0
        var totalValue: CGFloat = 0
        
        for (_, value) in self {
            
            totalValue += CGFloat(value)
            
            count += 1
        }
        
        return Double(totalValue / count)
    }
    
}
