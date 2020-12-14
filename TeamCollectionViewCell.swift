//
//  TeamCollectionViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/14.
//

import UIKit
import Kingfisher

class TeamCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImage: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamRatingLabel: UILabel!
    @IBOutlet weak var teamRatingImage: UIImageView!
    
    @IBOutlet weak var adminTitle: UILabel!
    @IBOutlet weak var adminName: UILabel!
    
    func setUi(team: Team) {
        if team.teamImage.isEmpty {
            teamImage.image = UIImage(named: "image_placeholder")
        } else {
            let url = URL(string: team.teamImage[0])
            teamImage.kf.setImage(with: url)
        }
        teamNameLabel.text = team.teamID
        adminName.text = team.adminID
        guard String(describing: team.teamRating.averageRating()) != "nan"
        else {
            teamRatingLabel.text = "尚未收到評分"
            return
        }
        teamRatingLabel.text = String(describing: team.teamRating.averageRating()) + " 顆星"
    }
}
