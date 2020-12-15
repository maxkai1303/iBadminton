//
//  TeamViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//

import UIKit
import ExpandingMenu
import CarLensCollectionViewLayout

class TeamViewController: UIViewController, UICollectionViewDelegate {
    
    var firebaseManager = FireBaseManager.shared
    var userId: String = ""
    var userName: String = ""
    var allTeam: [Team] = []
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOwnTeam()
        readTeam()
        setTitle()
        setupView()
    }
    
    func setTitle() {
  
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.maxColor(with: .mainBlue)
        ]
        
    }
    
    private func setupView() {
//        let viewHeight = UIScreen.main.bounds.height
//        let viewWidth = UIScreen.main.bounds.width
        teamCollectionView.backgroundColor = UIColor.maxColor(with: .mainBlue)
        teamCollectionView.register(TeamCollectionViewCell.self,
                                    forCellWithReuseIdentifier: TeamCollectionViewCell.identifier)
        teamCollectionView.showsHorizontalScrollIndicator = false
        teamCollectionView.collectionViewLayout = CarLensCollectionViewLayout()
//        let options = CarLensCollectionViewLayoutOptions(itemSize: CGSize(width: viewWidth - 32, height: viewHeight + 160))
//        teamCollectionView.collectionViewLayout = CarLensCollectionViewLayout(options: options)
    }
    
    @IBOutlet weak var teamCollectionView: UICollectionView!
    
    // MARK: 還需要判斷到底有沒有球隊
    func checkOwnTeam() {
        firebaseManager.checkLogin { uid in
            if uid == nil {
                if #available(iOS 13.0, *) {
                    let signInPage = self.storyboard?.instantiateViewController(identifier: "SignInViewController")
                    self.present(signInPage!, animated: true, completion: nil)
                }
            } else {
                self.userId = uid!
                self.setMenuButton()
                print("login \(self.userId)")
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
        let itemButtonSize: CGSize = CGSize(width: 30, height: 30)
        let menuButton = ExpandingMenuButton(
            frame: CGRect(origin: CGPoint.zero, size: menuButtonSize),
            image: #imageLiteral(resourceName: "settings"),
            rotatedImage: #imageLiteral(resourceName: "cancel"))
        menuButton.center = CGPoint(x: self.view.bounds.width - 38.0, y: self.view.bounds.height - 130.0)
        view.addSubview(menuButton)
        
        let itemEdit = ExpandingMenuItem(
            size: itemButtonSize,
            title: "修改球隊資訊",
            image: #imageLiteral(resourceName: "edit"),
            highlightedImage: #imageLiteral(resourceName: "edit"),
            backgroundImage: #imageLiteral(resourceName: "edit"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "edit")) { () -> Void in
            self.performSegue(withIdentifier: "showTeamEditView", sender: self)
        }
        itemEdit.titleColor = .white
        
        let itemNewPost = ExpandingMenuItem(
            size: menuButtonSize,
            title: "新增活動",
            image: #imageLiteral(resourceName: "writing"),
            highlightedImage: #imageLiteral(resourceName: "writing"),
            backgroundImage: #imageLiteral(resourceName: "writing"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "writing")) { () -> Void in
            self.performSegue(withIdentifier: "showAddActiveView", sender: self)
        }
        itemNewPost.titleColor = .white
        menuButton.addMenuItems([itemEdit, itemNewPost])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTeamEditView" {
            let controller = segue.destination as? TeamEditViewController
            controller?.userId = userId
        } else if segue.identifier == "showAddActiveView" {
            let controller = segue.destination as? AddActiveViewController
            controller?.userId = userId
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
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        team = allTeam[indexPath.row]
//        performSegue(withIdentifier: "goTeamDetail", sender: nil)
//    }
//}

//extension TeamViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let screenWidth = UIScreen.main.bounds.size.width - 30
//        let height = UIScreen.main.bounds.size.height * 0.35
//
//        return CGSize(width: screenWidth, height: height)
//    }
}
