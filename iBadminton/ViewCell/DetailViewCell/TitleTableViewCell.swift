//
//  TitleTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/27.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var checkTeamRating: UIButton!
    
}
