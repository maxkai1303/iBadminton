//
//  UpperLayerImageTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//

import UIKit

class UpperLayerImageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var leftImageOutlet: UIImageView!
    @IBOutlet weak var rightImageOutlet: UIImageView!
    

}
