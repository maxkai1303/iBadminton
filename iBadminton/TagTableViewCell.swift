//
//  TagTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/27.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var secondTagLine: UILabel!
    
}
