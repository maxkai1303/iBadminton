//
//  ViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/24.
//

import UIKit
import FirebaseAuth
import Lottie
//import LineSDK

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var homePageCollection: UICollectionView!
    
    private var height: CGFloat?
    
    var events: [Event] = []
    var team: [Team] = []
    var event: Event?
    
//    @IBOutlet weak var searchDateTextField: UITextField! {
//        didSet {
//            searchDateTextField.inputView = datePicker
//        }
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let tabBarHeight = tabBarController?.tabBar.frame.size.height {
            height = UIScreen.main.bounds.height - searchView.frame.height - tabBarHeight
            
            imageView.center = view.center
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.animate()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            
            guard let nextVC = segue.destination as? DetailViewController else {
                print("next view controller is nil")
                return
            }
            
            nextVC.detailEvent = event
        }
    }
    
    //  Launch Screen 動畫設定
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.image = UIImage(named: "i badminton")
        return imageView
    }()
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(
                x: -(diffX / 2),
                y: diffY / 2,
                width: size,
                height: size
            )
        })
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.imageView.removeFromSuperview()
                })
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 隱藏 navigation
        self.navigationController?.isNavigationBarHidden = true
        setUi()
        FireBaseManager.shared.listen(collectionName: .event) {
            self.readEvent()
        }
        view.addSubview(imageView)
    }
    
    func setUi() {
        // 設定 searchBar文字框顏色
        if let textfield = searchBarOutlet.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.textColor = UIColor.blue
        }
    }
    
    func readEvent() {
        FireBaseManager.shared.read(collectionName: .event, dataType: Event.self) { (result) in
            switch result {
            case .success(let event):
                self.events = event
                self.homePageCollection.reloadData()
            case .failure(let error): print("======== Home Page Set Data \(error.localizedDescription)=========")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homePageCollection.reloadData()
    }
    
    //  判斷有沒有登入後加入活動或是跳出登入畫面
    @IBAction func homeJoinButton(_ sender: UIButton) {
        FireBaseManager.shared.checkLogin { uid in
            if uid == nil {
                if #available(iOS 13.0, *) {
                    let signInPage = self.storyboard?.instantiateViewController(identifier: "SignInViewController")
                    self.present(signInPage!, animated: true, completion: nil)
                }
            } else {
                FireBaseManager.shared.joinEvent(
                    userId: uid!,
                    event: self.events[sender.tag].eventID,
                    lackCout: self.events[sender.tag].lackCount
                )
            }
        }
    }
    
    
    func readTeamRating(teamID: String, handler: @escaping (Team) -> Void) {
        let docRef = FireBaseManager.shared.fireDb.collection("Team").document("\(teamID)")
        docRef.getDocument { (document, _) in
            if let document = document {
                _ = document.data().map(String.init(describing:)) ?? "nil"

                guard let data = try? document.data(as: Team.self) else {
                    print("Team decod error ")
                    return
                }

                handler(data)

            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: 監聽活動狀態 status 變成 false不顯示
    // 感覺一開始拿的時候就直接拿 true就好，然後監聽整個 team
    func listenEvent() {
        let collection = FireBaseManager.shared.getCollection(name: .event)
        collection.whereField("status", isEqualTo: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    // numberofrow 放那個判斷如果是0的話給他動畫View不然就背景nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HomeCollectionViewCell",
                for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.setShadow()
        cell.setUi()
        
        readTeamRating(teamID: events[indexPath.row].teamID) { [self] (data) in
            cell.setup(data: self.events[indexPath.row], team: data, index: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        event = events[indexPath.row]
        performSegue(withIdentifier: "showDetailSegue", sender: nil)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.size.width - 20
        let height = UIScreen.main.bounds.size.height * 0.5
        
        return CGSize(width: screenWidth, height: height)
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
