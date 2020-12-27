//
//  TeamViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//

import UIKit
import ExpandingMenu
import CarLensCollectionViewLayout
import Firebase

class TeamViewController: UIViewController, UICollectionViewDelegate {
    
    var firebaseManager = FireBaseManager.shared
    var userId: String = ""
    var userName: String = ""
    var allTeam: [Team] = []
    var team: Team?
    var ownTeam: [Team] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readTeam()
        setTitle()
        setupView()
        
        guard let user = Auth.auth().currentUser else { return }
        self.userId = user.uid
        checkOwnTeam()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readTeam()
        checkOwnTeam()
//        teamCollectionView.reloadData()
    }
    
    func setTitle() {
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.maxColor(with: .mainBlue)
        ]
        
    }
    
    private func setupView() {
        teamCollectionView.backgroundColor = UIColor.maxColor(with: .mainBlue)
        teamCollectionView.register(TeamCollectionViewCell.self,
                                    forCellWithReuseIdentifier: TeamCollectionViewCell.identifier)
        teamCollectionView.showsHorizontalScrollIndicator = false
        teamCollectionView.collectionViewLayout = CarLensCollectionViewLayout()
    }
    
    @IBOutlet weak var teamCollectionView: UICollectionView!
    
    func listenTeam() {
        firebaseManager.listen(collectionName: .team) {
            self.readTeam()
        }
    }
    // 判斷有球隊才給他修改新增按鈕
    func checkOwnTeam() {
        firebaseManager.getOwnTeam(userId: self.userId) { result in
                if result.isEmpty == true {
                    print("This user not have any team!!")
                } else {
                    self.ownTeam = result
                    self.setMenuButton()
            }
        }
    }
        
        func readTeam() {
            firebaseManager.read(collectionName: .team, dataType: Team.self) { result in
                switch result {
                case .success(let team):
                    self.allTeam = team
                    self.teamCollectionView.reloadData()
                case .failure(let error): print("======== All Team Set Data \(error.localizedDescription)=========")
                }
            }
        }
        
        func setMenuButton() {
            let menuButtonSize: CGSize = CGSize(width: 40.0, height: 40.0)
            let menuButton = ExpandingMenuButton(
                frame: CGRect(origin: CGPoint.zero, size: menuButtonSize),
                image: #imageLiteral(resourceName: "settings"),
                rotatedImage: #imageLiteral(resourceName: "cancel"))
            menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 130.0)
            view.addSubview(menuButton)
            
            let itemEdit = ExpandingMenuItem(
                size: menuButtonSize,
                title: "編輯球隊資訊",
                image: #imageLiteral(resourceName: "joinTeam"),
                highlightedImage: #imageLiteral(resourceName: "joinTeam"),
                backgroundImage: #imageLiteral(resourceName: "circle"),
                backgroundHighlightedImage: #imageLiteral(resourceName: "circle")) { () -> Void in
                
                self.performSegue(withIdentifier: "showTeamEditView", sender: self)
            }
            
            let itemNewPost = ExpandingMenuItem(
                size: menuButtonSize,
                title: "新增活動",
                image: #imageLiteral(resourceName: "user"),
                highlightedImage: #imageLiteral(resourceName: "user"),
                backgroundImage: #imageLiteral(resourceName: "circle"),
                backgroundHighlightedImage: #imageLiteral(resourceName: "circle")) { () -> Void in
                
                self.performSegue(withIdentifier: "showAddActiveView", sender: self)
            }
            menuButton.addMenuItems([itemEdit, itemNewPost])
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showTeamEditView" {
                let controller = segue.destination as? TeamEditViewController
                controller?.userId = userId
                controller?.ownTeam = ownTeam
            } else if segue.identifier == "showAddActiveView" {
                let controller = segue.destination as? AddActiveViewController
                controller?.userId = userId
                controller?.ownTeam = ownTeam
            } else if segue.identifier == "goTeamDetail" {
                guard let controller = segue.destination as? TeamDetailViewController else {
                    print("next view controller is nil")
                    return
                }
                controller.teamDetail = team
            }
        }
        
    }
    
    extension TeamViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return allTeam.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TeamCollectionViewCell.identifier, for: indexPath)
                    as? TeamCollectionViewCell else { return UICollectionViewCell() }
            cell.layoutCell(team: allTeam[indexPath.row])
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            team = allTeam[indexPath.row]
            performSegue(withIdentifier: "goTeamDetail", sender: nil)
        }
    }
