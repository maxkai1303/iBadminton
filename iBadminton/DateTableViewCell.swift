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
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var lackCount: UILabel!
    
    func setUp(lack: Int, startDate: Timestamp, endDate: Timestamp) {
        dateLabel.text = FireBaseManager.shared.timeStampToStringDetail(startDate)
        endTimeLabel.text = FireBaseManager.shared.timeStampToStringDetail(endDate)
        lackCount.text = "缺 \(lack)"
    }
}
