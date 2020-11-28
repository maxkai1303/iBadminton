//
//  BallTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/28.
//

import UIKit

class BallTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var ballImage: UIImageView!
    
    @IBOutlet weak var ballLabel: UILabel!
    
}
