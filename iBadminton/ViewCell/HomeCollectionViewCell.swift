//
//  HomeCollectionViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/25.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var countRating: UILabel!
    @IBOutlet weak var averageStar: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var manPrice: UILabel!
    @IBOutlet weak var girlPrice: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelRating: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var lackCount: UILabel!
    @IBOutlet weak var plusOneButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    func setUi() {
        // 設定主要圖片上面兩個圓角
        mainImage.layer.cornerRadius = 5
        mainImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        plusOneButton.layer.cornerRadius = 5
        
    }
}
