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
    
    func layoutCell(team: Team) {
        let url = URL(string: team.teamImage)
        // MARK: 這裡硬拿，如果沒有admin會掛掉
        FireBaseManager.shared.getUserName(userId: team.adminID[0]) { (name) in
            self.adminNameLabel.text = name
        }
        teamImageView.kf.setImage(with: url)
        upperView.text = team.teamName
        //        if team.teamRating.averageRating().isNaN {
        //            teamRating.text = "尚未收到評分"
        //        } else {
        //            teamRating.text = "\(team.teamRating.averageRating())"
        //        }
        message.text = team.teamMessage
        teamImageView.layer.cornerRadius = 10
        teamImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    let teamImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "image_placeholder")
        imageView.backgroundColor = UIColor.maxColor(with: .lightBlue)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return imageView
    }()
    
    let adminLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang TC", size: 20)
        label.textColor = UIColor.maxColor(with: .mainBlue)
        label.text = "管理員:"
        return label
    }()
    
    let adminNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang TC", size: 20)
        label.textColor = UIColor.maxColor(with: .mainBlue)
        return label
    }()
    
    //    let teamRating: UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.font = UIFont(name: "PingFang TC", size: 16)
    //        label.textColor = UIColor.maxColor(with: .mainBlue)
    //        return label
    //    }()
    
    let message: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang TC", size: 16)
        label.textColor = UIColor.maxColor(with: .mainBlue)
        return label
    }()
    
    func addSubKit() {
        
        bottomView.addSubview(teamImageView)
        
        bottomView.addSubview(adminLabel)
        
        bottomView.addSubview(adminNameLabel)
        
        //        bottomView.addSubview(teamRating)
        
        bottomView.addSubview(message)
        
        NSLayoutConstraint.activate([
            teamImageView.heightAnchor.constraint(equalToConstant: 200),
            teamImageView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            teamImageView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            teamImageView.topAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            adminLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            adminLabel.topAnchor.constraint(equalTo: teamImageView.bottomAnchor, constant: 16),
            adminLabel.heightAnchor.constraint(equalToConstant: 30),
            adminLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            adminNameLabel.leadingAnchor.constraint(equalTo: adminLabel.trailingAnchor, constant: 5),
            adminNameLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            adminNameLabel.centerYAnchor.constraint(equalTo: adminLabel.centerYAnchor)
        ])
        
        //        NSLayoutConstraint.activate([
        //            teamRating.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
        //            teamRating.topAnchor.constraint(equalTo: adminLabel.bottomAnchor, constant: 16),
        //            teamRating.heightAnchor.constraint(equalToConstant: 30)
        //        ])
        
        NSLayoutConstraint.activate([
            message.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            message.topAnchor.constraint(equalTo: adminNameLabel.bottomAnchor, constant: 16),
            message.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            message.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16)
        ])
    }
    
    private var upperView: UILabel = {
        var teamName = UILabel()
        teamName.translatesAutoresizingMaskIntoConstraints = false
        teamName.font = .boldSystemFont(ofSize: 30)
        teamName.textAlignment = .center
        teamName.textColor = .white
        teamName.numberOfLines = 0
        teamName.lineBreakMode = .byCharWrapping
        return teamName
    }()
    
    var bottomView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(topView: upperView, cardView: bottomView, topViewHeight: 150)
        addSubKit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
