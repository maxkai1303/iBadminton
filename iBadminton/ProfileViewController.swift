//
//  ProfileViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/28.
//  swiftlint:disable all

import UIKit
import FirebaseAuth
import Kingfisher

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FireBaseManager.shared.checkLogin { uid in
            if uid == nil {
                if #available(iOS 13.0, *) {
                    let signInPage = self.storyboard?.instantiateViewController(identifier: "SignInViewController")
                    self.present(signInPage!, animated: true, completion: nil)
                }
            } else {
                self.userId = uid!
                self.read()
                self.setData()
                print("login \(self.userId)")
            }
        }
    }
    
    @IBAction func createTeam(_ sender: Any) {
        loginOut()
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
            } else {
                print("Document does not exist in cache")
            }
        }
    }
    
        func setData() {
            let url = URL(string: profileData?.userImage ?? "")
            userImage.kf.setImage(with: url)
            userName.text = profileData?.userName
            userRating.text = String(describing: profileData?.rating.averageRating()) + " 顆星"
            noShowCount.text = "\(profileData?.noShow ?? 0) 次"
            joinCount.text = "\(profileData?.joinCount ?? 0) 次"
        }
    
}
