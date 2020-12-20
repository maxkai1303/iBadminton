//
//  HomePageCollectionViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/20.
//

import UIKit
import CarLensCollectionViewLayout

class HomePageCollectionViewCell: CarLensCollectionViewCell {
    
    static let identifier = "homePageCollectionViewCell"
    
    func layoutCell(event: Event) {
        let url = URL(string: event.image[0])
        
        upperView.text = event.teamID
        eventImageView.kf.setImage(with: url)
        dateLabel.text = FireBaseManager.shared.timeStampToStringDetail(event.dateStart)
        location.setTitle(event.location, for: .normal)
        price.text = "\(event.price)"
        levelLabel.text = event.level
    }
    
    func getTeamRating(data: Team) {
        guard String(describing: data.teamRating.averageRating()) != "nan"
        else {
            teamRating.text = "尚未收到評分"
            return
        }
        teamRating.text = String(describing: data.teamRating.averageRating()) + " 顆星"
    }
    
    let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "image_placeholder")
        imageView.backgroundColor = UIColor.maxColor(with: .lightBlue)
        
        return imageView
    }()
    
    //MARK:-Date
    let dateIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "calendar")
        return image
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang TC", size: 16)
        label.textColor = UIColor.maxColor(with: .mainBlue)
        return label
    }()
    
    //MARK:-location
    
    let mapIcon: UIImageView = {
       let map = UIImageView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.contentMode = .scaleToFill
        map.image = UIImage(named: "map")
        return map
    }()
    
    let location: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 1
        // button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byTruncatingMiddle
        button.setTitleColor(UIColor.maxColor(with: .mainBlue), for: .normal)
        return button
    }()
    
    //MARK:-price
    
    let coinIcon: UIImageView = {
        let coin = UIImageView()
        coin.translatesAutoresizingMaskIntoConstraints = false
        coin.contentMode = .scaleToFill
        coin.image = UIImage(named: "dollar-coin")
        return coin
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang TC", size: 16)
        label.textColor = UIColor.maxColor(with: .mainBlue)
        return label
    }()
    //MARK:-level
    let rankIcon: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "medal-of-honor")
        return image
    }()
    
    let levelLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang TC", size: 16)
        label.textColor = UIColor.maxColor(with: .mainBlue)
        return label
    }()
    
    let ratingIcon: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "stars")
        return image
    }()
    
    let teamRating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang TC", size: 16)
        label.textColor = UIColor.maxColor(with: .yellow)
        return label
    }()
    
    
    
    func addSubKit() {
        
        bottomView.addSubview(eventImageView)
        
        bottomView.addSubview(dateIcon)
        bottomView.addSubview(dateLabel)
        
        bottomView.addSubview(mapIcon)
        bottomView.addSubview(location)
        
        bottomView.addSubview(coinIcon)
        bottomView.addSubview(price)
        
        bottomView.addSubview(rankIcon)
        bottomView.addSubview(levelLabel)
        
        bottomView.addSubview(ratingIcon)
        bottomView.addSubview(teamRating)
        
        NSLayoutConstraint.activate([
            eventImageView.heightAnchor.constraint(equalToConstant: 250),
            eventImageView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            eventImageView.topAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateIcon.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            dateIcon.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 16),
            dateIcon.widthAnchor.constraint(equalToConstant: 24),
            dateIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dateIcon.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            mapIcon.leadingAnchor.constraint(equalTo: dateIcon.leadingAnchor),
            mapIcon.topAnchor.constraint(equalTo: dateIcon.bottomAnchor, constant: 8),
            mapIcon.widthAnchor.constraint(equalToConstant: 24),
            mapIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            location.leadingAnchor.constraint(equalTo: mapIcon.trailingAnchor, constant: 16),
            location.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            location.centerYAnchor.constraint(equalTo: mapIcon.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rankIcon.leadingAnchor.constraint(equalTo: mapIcon.leadingAnchor),
            rankIcon.topAnchor.constraint(equalTo: mapIcon.bottomAnchor, constant: 8),
            rankIcon.widthAnchor.constraint(equalToConstant: 24),
            rankIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            levelLabel.leadingAnchor.constraint(equalTo: rankIcon.trailingAnchor, constant: 16),
            levelLabel.centerYAnchor.constraint(equalTo: rankIcon.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            coinIcon.leadingAnchor.constraint(equalTo: rankIcon.leadingAnchor),
            coinIcon.topAnchor.constraint(equalTo: rankIcon.bottomAnchor, constant: 8),
            coinIcon.widthAnchor.constraint(equalToConstant: 24),
            coinIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            price.leadingAnchor.constraint(equalTo: coinIcon.trailingAnchor, constant: 16),
            price.centerYAnchor.constraint(equalTo: coinIcon.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ratingIcon.leadingAnchor.constraint(equalTo: coinIcon.leadingAnchor),
            ratingIcon.topAnchor.constraint(equalTo: coinIcon.bottomAnchor, constant: 8),
            ratingIcon.widthAnchor.constraint(equalToConstant: 24),
            ratingIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            teamRating.leadingAnchor.constraint(equalTo: ratingIcon.trailingAnchor, constant: 16),
            teamRating.centerYAnchor.constraint(equalTo: ratingIcon.centerYAnchor)
        ])
    }
    
    private var upperView: UILabel = {
        var teamName = UILabel()
        teamName.translatesAutoresizingMaskIntoConstraints = false
        teamName.font = .boldSystemFont(ofSize: 24)
        teamName.textAlignment = .center
        teamName.textColor = .white
        return teamName
    }()
    
    private var bottomView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(topView: upperView, cardView: bottomView, topViewHeight: 100)
        addSubKit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
}
