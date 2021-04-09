//
//  JoinMemberTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/25.
//

import UIKit

class JoinMemberTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var joinNameLabel: UILabel!
    
    func setUi(member: String) {
        
            FireBaseManager.shared.getUserName(userId: member) { (name) in
                
                self.joinNameLabel.text = name
        }
    }
}
