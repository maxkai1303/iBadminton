//
//  TeamDetailViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/14.
//

import UIKit
import Kingfisher

class TeamDetailViewController: UIViewController {
    
    var image: String = ""
    var teamName: String = ""
    var teamRating: String = ""
    var adminName: String = ""
    
    var teamDetail: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        setLabel()
    }
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamRatingLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamAdminLabel: UILabel!
    @IBOutlet weak var teamNoteLabel: UILabel!
    
    func setLabel() {
        teamNameLabel.text = teamDetail?.teamID
        let teamRating = String(describing: teamDetail?.teamRating.averageRating())
        if  teamRating == "nil" {
            teamRatingLabel.text = "尚未收到評分"
        } else if teamRating.isEmpty {
            teamRatingLabel.text = "尚未收到評分"
        } else {
            teamRatingLabel.text = teamRating
        }
        
        teamRatingLabel.text! = "\(teamRating)"
        guard teamDetail?.teamImage.count != nil
        else {
            teamImage.image = UIImage(named: "image_placeholder")
            return
        }
        let url = URL(string: teamDetail!.teamImage[0])
        teamImage.kf.indicatorType = .activity
        teamImage.kf.setImage(with: url)
        teamAdminLabel.text = teamDetail?.adminID
        teamNoteLabel.text = teamDetail?.teamMessage
    }
}
