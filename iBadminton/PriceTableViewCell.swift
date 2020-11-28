//
//  PriceTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/28.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var priceImage: UIImageView!
    
    @IBOutlet weak var malePrice: UILabel!
    @IBOutlet weak var femalePrice: UILabel!
    
}
