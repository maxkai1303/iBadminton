//
//  TeamViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//

import UIKit
import ExpandingMenu

class TeamViewController: UIViewController, UITableViewDelegate {
    
    var firebaseManager = FireBaseManager.shared
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkOwnTeam()
    }
    
    @IBOutlet weak var teamTableView: UITableView!
    
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
    
    func setMenuButton() {
        let menuButtonSize: CGSize = CGSize(width: 70.0, height: 70.0)
        let menuButton = ExpandingMenuButton(
            frame: CGRect(origin: CGPoint.zero, size: menuButtonSize),
            image: #imageLiteral(resourceName: "settings"),
            rotatedImage: #imageLiteral(resourceName: "cancel"))
        menuButton.center = CGPoint(x: self.view.bounds.width - 38.0, y: self.view.bounds.height - 130.0)
        view.addSubview(menuButton)
        
        let itemEdit = ExpandingMenuItem(
            size: menuButtonSize,
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
        }
    }
    
}

extension TeamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "teamTitleTableViewCell", for: indexPath)
                    as? TeamTitleTableViewCell else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "upperLayerImageTableViewCell", for: indexPath)
                    as? UpperLayerImageTableViewCell else { return UITableViewCell() }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "lowerImageTableViewCell", for: indexPath)
                    as? LowerImageTableViewCell else { return UITableViewCell() }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "teamBallTableViewCell", for: indexPath)
                    as? TeamBallTableViewCell else { return UITableViewCell() }
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "teamNoteTableViewCell", for: indexPath)
                    as? TeamNoteTableViewCell else { return UITableViewCell() }
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "teamManberTableViewCell", for: indexPath)
                    as? TeamManberTableViewCell else { return UITableViewCell() }
            // 這邊還要呼叫球隊成員的 func
            return cell
        default:
            return UITableViewCell()
        }
    }
}
