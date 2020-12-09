//
//  LocationTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/28.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    
    func setUp(location: String) {
        locationButton.setTitle(location, for: .normal)
    }
}
