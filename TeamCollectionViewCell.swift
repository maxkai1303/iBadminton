//
//  TeamCollectionViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/14.
//

import UIKit
import Kingfisher
import CarLensCollectionViewLayout

class TeamCollectionViewCell: CarLensCollectionViewCell {
    
    static let identifier = "TeamCollectionViewCell"
    
    
    
        private var upperView: UILabel = {
          var teamName = UILabel()

            teamName.translatesAutoresizingMaskIntoConstraints = false
            teamName.font = .boldSystemFont(ofSize: 30)
            teamName.textAlignment = .center
            teamName.textColor = .white
            teamName.text = "天仁茗茶生命之泉源"
            return teamName
        }()
        
        private var bottomView: UIView = {
            var view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            
//            var teamImage = UIImage(named: "image_placeholder")
//            imageWrapperView.addSubview(teamImage)
            
            var adminLabel = UILabel()
            adminLabel.translatesAutoresizingMaskIntoConstraints = false
            adminLabel.font = UIFont(name: "PingFang TC", size: 20)
            adminLabel.textColor = UIColor.maxColor(with: .mainBlue)
            adminLabel.text = "球隊管理員:"
            view.addSubview(adminLabel)
            NSLayoutConstraint.activate([
                adminLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                adminLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
            ])
            var adminName = UILabel()
            adminName.translatesAutoresizingMaskIntoConstraints = false
            adminName.font = UIFont(name: "PingFang TC", size: 20)
            adminName.textColor = UIColor.maxColor(with: .mainBlue)
            adminName.text = "Max"
            view.addSubview(adminName)
            NSLayoutConstraint.activate([
                adminName.leadingAnchor.constraint(equalTo: adminLabel.trailingAnchor, constant: 16),
                adminName.centerYAnchor.constraint(equalTo: adminLabel.centerYAnchor)
            ])
            
            var teamRating = UILabel()
            teamRating.translatesAutoresizingMaskIntoConstraints = false
            teamRating.font = UIFont(name: "PingFang TC", size: 16)
            teamRating.textColor = UIColor.maxColor(with: .mainBlue)
            teamRating.text = "4.9 顆星"
            view.addSubview(teamRating)
            NSLayoutConstraint.activate([
                teamRating.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                teamRating.topAnchor.constraint(equalTo: adminLabel.bottomAnchor, constant: 16)
            ])
            
            var message = UILabel()
            message.translatesAutoresizingMaskIntoConstraints = false
            message.font = UIFont(name: "PingFang TC", size: 16)
            message.textColor = UIColor.maxColor(with: .mainBlue)
            message.text = """
            觀自在菩薩，行深般若波羅蜜多時，照見五蘊皆空，度一切苦厄。
            舍利子！色不異空，空不異色；色即是空，空即是色，受想行識亦復如是。
            舍利子！是諸法空相，不生不滅，不垢不淨，不增不減。
            是故，空中無色，無受想行識；無眼耳鼻舌身意；無色聲香味觸法；
            無眼界，乃至無意識界；無無明，亦無無明盡，乃至無老死，亦無老死盡；
            無苦集滅道；無智亦無得。以無所得故，菩提薩埵。
            依般若波羅蜜多故，心無罣礙；無罣礙故，無有恐怖，遠離顛倒夢想，究竟涅槃。
            三世諸佛，依般若波羅蜜多故，得阿耨多羅三藐三菩提。
"""
            view.addSubview(message)
            NSLayoutConstraint.activate([
                message.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                message.topAnchor.constraint(equalTo: teamRating.bottomAnchor, constant: 16),
                message.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                message.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
            
            return view
        }()
    
//    @IBOutlet weak var teamImage: UIImageView!
//
//    @IBOutlet weak var teamNameLabel: UILabel!
//    @IBOutlet weak var teamRatingLabel: UILabel!
//    @IBOutlet weak var teamRatingImage: UIImageView!
//
//    @IBOutlet weak var adminTitle: UILabel!
//    @IBOutlet weak var adminName: UILabel!
    
//    func setUi(team: Team) {
//        if team.teamImage.isEmpty {
//            teamImage.image = UIImage(named: "image_placeholder")
//        } else {
//            let url = URL(string: team.teamImage[0])
//            teamImage.kf.setImage(with: url)
//        }
//        teamNameLabel.text = team.teamID
//        adminName.text = team.adminID
//        guard String(describing: team.teamRating.averageRating()) != "nan"
//        else {
//            teamRatingLabel.text = "尚未收到評分"
//            return
//        }
//        teamRatingLabel.text = String(describing: team.teamRating.averageRating()) + " 顆星"
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(topView: upperView, cardView: bottomView, topViewHeight: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
