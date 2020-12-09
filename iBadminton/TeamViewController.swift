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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuButton()
    }
    
    @IBOutlet weak var teamTableView: UITableView!
    
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
            self.performSegue(withIdentifier: "showTeamEditView", sender: nil)
            self.firebaseManager.edit(collectionName: .event) { }
        }
        itemEdit.titleColor = .white
        
        let itemNewPost = ExpandingMenuItem(
            size: menuButtonSize,
            title: "新增活動",
            image: #imageLiteral(resourceName: "writing"),
            highlightedImage: #imageLiteral(resourceName: "writing"),
            backgroundImage: #imageLiteral(resourceName: "writing"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "writing")) { () -> Void in
            self.performSegue(withIdentifier: "showAddActiveView", sender: nil)
            self.firebaseManager.addEvent(collectionName: .event) { }
        }
        itemNewPost.titleColor = .white
        menuButton.addMenuItems([itemEdit, itemNewPost])
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
            return cell
        default:
            return UITableViewCell()
        }
    }
}
