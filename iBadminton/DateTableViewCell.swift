//
//  DateTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/28.
//

import UIKit
import Firebase

class DateTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var lackCount: UILabel!
    
    func setUp(lack: Int, date: Timestamp) {
        dateLabel.text = "\(date)"
        lackCount.text = "缺 \(lack)"
    }
}
