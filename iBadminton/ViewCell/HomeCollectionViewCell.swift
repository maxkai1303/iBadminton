//
//  HomeCollectionViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/25.
//

import UIKit
import Kingfisher
import Firebase

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var averageStar: UILabel!
    
    @IBOutlet weak var manPrice: UILabel!
    
    @IBOutlet weak var level: UILabel!

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
    
    func setup(data: Event, team: Team, index: Int) {
        let url = URL(string: "\(data.image[0])")
        mainImage.kf.setImage(with: url)
        manPrice.text = "\(data.price)"
        teamNameLabel.text = data.teamID
        level.text = data.level
        startTime.text = timeStampToStringDetail(data.dateStart)
        locationButton.setTitle(data.location, for: .normal)
        lackCount.text = "\(data.lackCount)"
        getTeamRating(data: team)
        
        plusOneButton.tag = index
    }
    
    func getTeamRating(data: Team) {
        averageStar.text = String(describing: data.teamRating.averageRating()) + " 顆星"
    }
    
    func timeStampToStringDetail(_ timeStamp: Timestamp) -> String {
        let timeSta = timeStamp.dateValue()
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dfmatter.string(from: timeSta)
    }
    
}
