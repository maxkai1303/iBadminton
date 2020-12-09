//
//  NoteTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/28.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBOutlet weak var noteImage: UIImageView!
  
    @IBOutlet weak var noteLabel: UILabel!
    
    func setUp(note: String) {
        noteLabel.text = note
    }
    
}
