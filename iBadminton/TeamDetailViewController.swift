//
//  TeamDetailViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/14.
//

import UIKit
import Kingfisher
import ExpandingMenu
import PKHUD

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
        setMenuButton()
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
            controller?.teamName = teamDetail?.teamName ?? ""
        }
        if segue.identifier == "showTeamManber" {
            
            let controller = segue.destination as? TeamManberViewController
            controller?.team = teamDetail
            
        }
        
        if segue.identifier == "goTeamRating" {
            
            let controller = segue.destination as? TeamRatingViewController
            controller?.team = teamDetail
            
        }
    }
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamRatingLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamAdminLabel: UILabel!
    @IBOutlet weak var teamNoteLabel: UILabel!
    
    func setMenuButton() {
        
        let menuButtonSize: CGSize = CGSize(width: 40.0, height: 40.0)
        
        let menuButton = ExpandingMenuButton(
            frame: CGRect(origin: CGPoint.zero, size: menuButtonSize),
            image: #imageLiteral(resourceName: "settings"),
            rotatedImage: #imageLiteral(resourceName: "cancel"))
        
        menuButton.center = CGPoint(x: self.view.bounds.width - 38.0, y: self.view.bounds.height - 130.0)
        
        view.addSubview(menuButton)
        
        let itemJoin = ExpandingMenuItem(
            size: menuButtonSize,
            title: "加入球隊",
            image: #imageLiteral(resourceName: "joinTeam"),
            highlightedImage: #imageLiteral(resourceName: "joinTeam"),
            backgroundImage: #imageLiteral(resourceName: "circle"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "circle")) { () -> Void in
            
            FireBaseManager.shared.checkLogin { (uid) in
                
                if uid == nil {
                    
                    if #available(iOS 13.0, *) {
                        let signInPage = self.storyboard?.instantiateViewController(identifier: "SignInViewController")
                        self.present(signInPage!, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    guard let teamId = self.teamDetail?.teamID else { return }
                    
                    FireBaseManager.shared.getUserName(userId: uid!) { (name) in
                        
                        guard let name = name, !name.isEmpty else { return }
                        
                        FireBaseManager.shared.checkJoinTeam(userId: uid!, teamId: teamId, name: name)
                    }
                }
            }
            //            self.performSegue(withIdentifier: "goTeamRating", sender: self)
        }
        
//        itemJoin.titleColor = .white
//
        let itemMember = ExpandingMenuItem(
            size: menuButtonSize,
            title: "球隊成員",
            image: #imageLiteral(resourceName: "group whole body"),
            highlightedImage: #imageLiteral(resourceName: "group whole body"),
            backgroundImage: #imageLiteral(resourceName: "circle"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "circle")) { () -> Void in
            self.performSegue(withIdentifier: "showTeamManber", sender: self)
        }
//
        itemMember.titleColor = .white

        let itemLine = ExpandingMenuItem(
            size: menuButtonSize,
            title: "球隊動態",
            image: #imageLiteral(resourceName: "timeline"),
            highlightedImage: #imageLiteral(resourceName: "timeline"),
            backgroundImage: #imageLiteral(resourceName: "circle"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "edit")) { () -> Void in
            self.performSegue(withIdentifier: "showTeamLine", sender: self)
        }

        itemLine.titleColor = .white

        menuButton.addMenuItems([itemJoin, itemMember, itemLine])
    }
    
    func setLabel() {
        
        teamNameLabel.text = teamDetail?.teamName
        
        //        guard let rating = teamDetail?.teamRating.averageRating() else { return }
        //
        //        teamRating = String(describing: rating)
        //
        //        if rating.isNaN {
        //            teamRatingLabel.text = "尚未收到評分"
        //        } else {
        //            teamRatingLabel.text = teamRating + " 顆星"
        //        }
        
        guard teamDetail?.teamImage.isEmpty == false else {
            
            teamImage.image = UIImage(named: "image_placeholder")
            
            return
        }
        
        let url = URL(string: teamDetail!.teamImage)
        
        teamImage.kf.indicatorType = .activity
        teamImage.kf.setImage(with: url)
        
        FireBaseManager.shared.getUserName(userId: teamDetail!.adminID[0]) { (name) in
            
            self.teamAdminLabel.text = name
            
        }
        
        teamNoteLabel.text = teamDetail?.teamMessage
        
    }
}
