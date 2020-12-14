//
//  ProfileViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/28.
//  swiftlint:disable all

import UIKit
import FirebaseAuth
import Kingfisher

protocol ProfileData: class {
    
      func  receiveData(data: String)
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRating: UILabel!
    
    @IBOutlet weak var noShowCount: UILabel!
    @IBOutlet weak var joinCount: UILabel!
    
    @IBOutlet weak var createTeamOutlet: UIButton!
    @IBOutlet weak var messageOutlet: UIButton!
    
    var profileData: User?
    var userId: String = ""
    var nickName: String = ""
    
    weak var delegate: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goInProfileSegue" {
            let controller = segue.destination as? InProfileViewController
            controller?.userId = userId
            controller?.userName = nickName
            
//            delegate = controller.self
        }
        if segue.identifier == "goCerateTeam" {
            let controller = segue.destination as? CreateTeamViewController
            controller?.userId = userId
            controller?.userName = nickName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       getData()
    }
    
    
    @IBAction func createTeam(_ sender: Any) {
    }
    
    
    @IBAction func editProfile(_ sender: Any) {
        setEditAlert()
    }
    @IBAction func mailButton(_ sender: Any) {
        loginOut()
    }
    
    // MARK: - func 
    
    // 確認有沒有登入，抓取用戶資料顯示
    func getData() {
        FireBaseManager.shared.checkLogin { uid in
            if uid == nil {
                if #available(iOS 13.0, *) {
                    let signInPage = self.storyboard?.instantiateViewController(identifier: "SignInViewController")
                    self.present(signInPage!, animated: true, completion: nil)
                }
            } else {
                self.userId = uid!
                self.read()
                self.delegate?.receiveData(data: self.nickName)
                print("login \(self.userId)")
            }
        }
    }
    
    func loginOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("===== LoginOut Success! =====")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func read() {
        let doc = FireBaseManager.shared.fireDb.collection("User").document(userId)
        doc.getDocument { (document, error) in
            if let document = document {
                guard let data = try? document.data(as: User.self) else {
                    return
                }
                
                self.profileData = data
                print(self.profileData ?? "")
                self.setLabel()
            } else {
                print("Document does not exist in cache")
            }
        }
    }
    
        func setLabel() {
            let url = URL(string: profileData?.userImage ?? "")
            userImage.kf.setImage(with: url)
            userName.text = profileData?.userName
            noShowCount.text = "\(profileData?.noShow ?? 0) 次"
            joinCount.text = "\(profileData?.joinCount ?? 0) 次"
            guard String(describing: profileData!.rating.averageRating()) != "nan"
            else {
                userRating.text = "尚未收到評分"
                return
            }
            userRating.text = String(describing: profileData!.rating.averageRating()) + " 顆星"
            
        }
    
    func setEditAlert() {
        let controller = UIAlertController(
            title: "修改暱稱",
            message: "請輸入暱稱",
            preferredStyle: .alert
        )
        controller.addTextField { (textField) in
            textField.placeholder = "您的暱稱"
            textField.keyboardType = .default
        }
        let okAction = UIAlertAction(title: "完成", style: .default) { (_) in
            guard controller.textFields?[0].text != "" else { return }
            self.nickName = (controller.textFields?[0].text)!
            self.userName.text = self.nickName
            FireBaseManager.shared.edit(collectionName: .user, userId: self.userId, key: "userName", value: "\(self.nickName)") { }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
    
}
