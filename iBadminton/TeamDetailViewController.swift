//
//  TeamDetailViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/14.
//

import UIKit

class TeamDetailViewController: UIViewController {
    
    var image: String = ""
    var teamName: String = ""
    var teamRating: Double = 0
    var adminName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamRatingLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamAdminLabel: UILabel!
    @IBOutlet weak var teamNoteLabel: UILabel!
    

    
    func setLabel() {
        teamNameLabel.text = teamName
        teamRatingLabel.text = "\(teamRating)"
        let url = URL(string: image)
        teamImage.kf.setImage(with: url)
        teamAdminLabel.text = adminName
    }
}
