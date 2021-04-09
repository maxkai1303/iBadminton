//
//  TagCollectionViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/9.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    
    func setTag(tag: String) {
        
        tagLabel.text = tag
    }
}
