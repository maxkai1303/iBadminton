//
//  TeamRatingTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/7.
//

import UIKit

class TeamRatingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingContent: UILabel!
    
}
