//
//  ViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/24.
//

import UIKit
import FirebaseFirestore
//import LineSDK

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var searchDateTextField: UITextField! {
        didSet {
            searchDateTextField.inputView = datePicker
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 隱藏 navigation
        self.navigationController?.isNavigationBarHidden = true
        setUi()
        listen()
    }
    
    let fireDb = Firestore.firestore()
    
    func listen() {
        fireDb.collection("Event").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let data = document.documents[0].data()
                  print("監聽到的資料: \(data)")
                }
    }
    
    func setUi() {
        // 設定 searchBar文字框顏色
        if let textfield = searchBarOutlet.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.textColor = UIColor.blue
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
