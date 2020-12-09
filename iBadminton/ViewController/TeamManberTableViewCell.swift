//
//  TeamManberTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/9.
//

import UIKit

class TeamManberTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setManber(data: [String]) {
        for item in 0 ..< data.count {
            let manberLebel = UILabel(frame: CGRect(x: 28, y: CGFloat(19 + 24 * item), width: UIScreen.main.bounds.width - 8, height: 36))
        }
    }

}
