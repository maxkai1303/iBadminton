//
//  ImageTableViewCell.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/27.
//

import UIKit

class ImageTableViewCell: UITableViewCell, UICollectionViewDelegate {

    var imageArray: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    func setUp(event: Event) {
        imageArray = event.image
    }
}

extension ImageTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "imageCollectionViewCell",
                for: indexPath) as? ImageCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setImage(image: imageArray[indexPath.row])
        return cell
    }
}

//extension ImageTableViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 375, height: 236)
//    }
//}
