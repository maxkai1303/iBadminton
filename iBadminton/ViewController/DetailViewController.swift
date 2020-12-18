//
//  DetailViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/27.
//

import UIKit
import ExpandingMenu
import FirebaseAuth

class DetailViewController: UIViewController, UITableViewDelegate {
    
    var detailEvent: Event?
    
    enum ButtonFunction {
        case joinTeam
        case joinPlay
    }
    
    @IBOutlet weak var detailTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuButton()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setMenuButton() {
        let menuButtonSize: CGSize = CGSize(width: 40.0, height: 40.0)
        let menuButton = ExpandingMenuButton(
            frame: CGRect(origin: CGPoint.zero, size: menuButtonSize),
            image: #imageLiteral(resourceName: "add"),
            rotatedImage: #imageLiteral(resourceName: "cancel"))
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 70.0)
        view.addSubview(menuButton)
        
        let item1 = ExpandingMenuItem(
            size: menuButtonSize,
            title: "申請加入球隊",
            image: #imageLiteral(resourceName: "badminton-court"),
            highlightedImage: #imageLiteral(resourceName: "badminton-court"),
            backgroundImage: #imageLiteral(resourceName: "circle"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "badminton-court")) { () -> Void in
            self.detailJoin(buttonFunc: .joinTeam)
        }
        
        let item5 = ExpandingMenuItem(
            size: menuButtonSize,
            title: "加入零打",
            image: #imageLiteral(resourceName: "shuttlecock"),
            highlightedImage: #imageLiteral(resourceName: "shuttlecock"),
            backgroundImage: #imageLiteral(resourceName: "circle"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "shuttlecock")) { () -> Void in
            self.detailJoin(buttonFunc: .joinPlay)
        }
        
        menuButton.addMenuItems([item1, item5])
    }
    
    func detailJoin(buttonFunc: ButtonFunction) {
        
        FireBaseManager.shared.checkLogin { (uid) in
            
            guard let userId = uid else {
                if #available(iOS 13.0, *) {
                    let signInPage = self.storyboard?.instantiateViewController(identifier: "SignInViewController")
                    self.present(signInPage!, animated: true, completion: nil)
                }
                return
            }
            
            switch buttonFunc {
            
            case .joinTeam:
                
                guard let team = self.detailEvent else {
                    print("event is nil")
                    return
                }
                FireBaseManager.shared.joinTeam(userId: userId, teamID: team.teamID)
                FireBaseManager.shared.getUserName(userId: userId) { (resutl) in
                    FireBaseManager.shared.addTimeline(team: team.teamID, content: "\(String(describing: resutl)) 加入球隊", event: false)
                }
                
            case .joinPlay:
                
                guard let event = self.detailEvent else {
                    print("event is nil")
                    return
                }
                
                FireBaseManager.shared.joinEvent(userId: userId, event: event.eventID, lackCout: event.lackCount)
            }
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "imageTableViewCell", for: indexPath)
                    as? ImageTableViewCell, let data = detailEvent else { return UITableViewCell() }
            cell.setUp(event: data)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "titleTableViewCell", for: indexPath)
                    as? TitleTableViewCell else { return UITableViewCell() }
            cell.setUp(teamID: detailEvent?.teamID ?? "")
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "tagTableViewCell", for: indexPath)
                    as? TagTableViewCell, let data = detailEvent else { return UITableViewCell() }
            cell.setUp(tag: data)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "dateTableViewCell", for: indexPath)
                    as? DateTableViewCell, let data = detailEvent else { return UITableViewCell() }
            cell.setUp(lack: data.lackCount, date: data.dateStart)
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "locationTableViewCell", for: indexPath)
                    as? LocationTableViewCell, let data = detailEvent else { return UITableViewCell() }
            cell.setUp(location: data.location)
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ballTableViewCell", for: indexPath)
                    as? BallTableViewCell, let data = detailEvent else { return UITableViewCell() }
            cell.setUp(ball: data.ball)
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "priceTableViewCell", for: indexPath)
                    as? PriceTableViewCell, let data = detailEvent else { return UITableViewCell() }
            cell.setUp(price: data.price)
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "noteTableViewCell", for: indexPath)
                    as? NoteTableViewCell, let data = detailEvent else { return UITableViewCell() }
            cell.setUp(note: data.note)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
