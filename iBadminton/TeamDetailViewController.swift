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
    var teamLineData: [TeamPoint] = []
    
    func getTeamLine() {
        guard let teamId = teamDetail?.teamID else { return }
        let teamLine = FireBaseManager.shared.getCollection(name: .team).document(teamId)
        teamLine.collection("TeamPoint").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard querySnapshot?.documents == nil else { return }
                
                FireBaseManager.shared.decode(TeamPoint.self, documents: querySnapshot!.documents) { (result) in
                    
                    switch result {
                    
                    case .success(let data):
                        self.teamLineData = data
                    case .failure(let error):
                        print("======= Decode Error \(error) =======")
                    }
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        setLabel()
        getTeamLine()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTeamLine" {
            let controller = segue.destination as? TimeLineViewController
            controller?.data = teamLineData
            controller?.teamId = teamDetail?.teamID ?? ""
        }
    }
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamRatingLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamAdminLabel: UILabel!
    @IBOutlet weak var teamNoteLabel: UILabel!
    
    func setLabel() {
        teamNameLabel.text = teamDetail?.teamID
        let teamRating = String(describing: teamDetail?.teamRating.averageRating())
        if  teamRating == "Optional(nan)" {
            teamRatingLabel.text = "尚未收到評分"
        } else if teamRating.isEmpty {
            teamRatingLabel.text = "尚未收到評分"
        } else {
            teamRatingLabel.text = teamRating
        }
        
        teamRatingLabel.text! = "\(teamRating)"
        guard ((teamDetail?.teamImage.isEmpty) != nil)
        else {
            teamImage.image = UIImage(named: "image_placeholder")
            return
        }
        let url = URL(string: teamDetail!.teamImage)
        teamImage.kf.indicatorType = .activity
        teamImage.kf.setImage(with: url)
        FireBaseManager.shared.getUserName(userId: teamDetail?.adminID ?? "") { (name) in
            self.teamAdminLabel.text = name
        }
        teamNoteLabel.text = teamDetail?.teamMessage
    }
}
