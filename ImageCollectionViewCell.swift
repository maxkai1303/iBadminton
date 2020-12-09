//
//  ImageCollectionViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/27.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(image: String) {
        let url = URL(string: image)
        imageView.kf.setImage(with: url)
    }
}
