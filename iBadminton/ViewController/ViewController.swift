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
    @IBOutlet weak var searchView: UIView!
    
    private var height: CGFloat?
    
    @IBOutlet weak var searchDateTextField: UITextField! {
        didSet {
            searchDateTextField.inputView = datePicker
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
            
            height = UIScreen.main.bounds.height - searchView.frame.height - tabBarHeight
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 隱藏 navigation
        self.navigationController?.isNavigationBarHidden = true
        setUi()
        FireBaseManager.shared.listen(collectionName: .event) { }
//        FireBaseManager.shared.read(collectionName: .event, dataType: Event.self) { (result) in
//            switch result {
//            case .success(let event):
//
//            case .failure(let error):
//            }
//        }
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenWidth = UIScreen.main.bounds.size.width - 20
            
            return CGSize(width: screenWidth, height: height ?? 430)
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
