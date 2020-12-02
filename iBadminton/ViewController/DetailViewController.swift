//
//  DetailViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/27.
//

import UIKit
import ExpandingMenu

class DetailViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuButton()
    }
    
    func setMenuButton() {
        let menuButtonSize: CGSize = CGSize(width: 80.0, height: 80.0)
        let menuButton = ExpandingMenuButton(
            frame: CGRect(origin: CGPoint.zero, size: menuButtonSize),
            image: #imageLiteral(resourceName: "add"),
            rotatedImage: #imageLiteral(resourceName: "cancel"))
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 130.0)
        view.addSubview(menuButton)
        
        let item1 = ExpandingMenuItem(
            size: menuButtonSize,
            title: "申請加入球隊",
            image: #imageLiteral(resourceName: "badminton-court"),
            highlightedImage: #imageLiteral(resourceName: "badminton-court"),
            backgroundImage: #imageLiteral(resourceName: "circle"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "badminton-court")) { () -> Void in
            // Do some action
        }
        
        let item5 = ExpandingMenuItem(
            size: menuButtonSize,
            title: "加入零打",
            image: #imageLiteral(resourceName: "shuttlecock"),
            highlightedImage: #imageLiteral(resourceName: "shuttlecock"),
            backgroundImage: #imageLiteral(resourceName: "circle"),
            backgroundHighlightedImage: #imageLiteral(resourceName: "shuttlecock")) { () -> Void in
            // Do some action
        }
        
        menuButton.addMenuItems([item1, item5])
        
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
                    as? ImageTableViewCell else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "titleTableViewCell", for: indexPath)
                    as? TitleTableViewCell else { return UITableViewCell() }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "tagTableViewCell", for: indexPath)
                    as? TagTableViewCell else { return UITableViewCell() }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "dateTableViewCell", for: indexPath)
                    as? DateTableViewCell else { return UITableViewCell() }
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "locationTableViewCell", for: indexPath)
                    as? LocationTableViewCell else { return UITableViewCell() }
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ballTableViewCell", for: indexPath)
                    as? BallTableViewCell else { return UITableViewCell() }
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "priceTableViewCell", for: indexPath) as? PriceTableViewCell else { return UITableViewCell() }
            return cell
        case 7:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "noteTableViewCell", for: indexPath)
                    as? NoteTableViewCell else { return UITableViewCell() }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
