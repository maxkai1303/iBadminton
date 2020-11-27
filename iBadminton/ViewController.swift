//
//  ViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/24.
//

import UIKit
//import LineSDK

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var searchDateTextField: UITextField! {
        didSet {
            searchDateTextField.inputView = datePicker
        }
    }
    
    let searchManager = SearchViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 隱藏 navigation
        self.navigationController?.isNavigationBarHidden = true
        setUi()
    }
    
    func setUi() {
        // 設定 searchBar文字框顏色
        searchBarOutlet.barTintColor = .white
        if let textfield = searchBarOutlet.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = .white
            textfield.textColor = .white
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HomeCollectionViewCell",
            for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.setShadow()
        cell.setUi()
        return cell
    }
}

extension UIView {
    func setShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1
    }
}
