//
//  TeamBallTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//

import UIKit

class TeamBallTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var ballTitleLabel: UILabel!
    @IBOutlet weak var ballLabel: UILabel!

    
}
