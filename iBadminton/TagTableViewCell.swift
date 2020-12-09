//
//  TagTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/27.
//

import UIKit

class TagTableViewCell: UITableViewCell, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var eventTag: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(tag: Event) {
        eventTag = tag.tag
    }
}

extension TagTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "tagCollectionViewCell", for: indexPath)
                as? TagCollectionViewCell else { return UICollectionViewCell() }
        cell.setTag(tag: eventTag[indexPath.row])
        return cell
    }
}
