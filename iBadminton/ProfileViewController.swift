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
    
    var profileData: [Uesr] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FireBaseManager.shared.listen(collectionName:.user) {
            self.read()
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
        FireBaseManager.shared.read(collectionName: .user, dataType: Uesr.self) { (result) in
            switch result {
            case .success(let user):
                self.profileData = user
                self.setData()
            case .failure(let error): print("======== Home Page Set Data \(error.localizedDescription)=========")
            }
        }
    }
    
    func setData() {
        let url = URL(string: profileData[0].userImage)
        userImage.kf.setImage(with: url)
        userName.text = profileData[0].userName
        userRating.text = String(describing: profileData[0].rating.averageRating()) + " 顆星"
        noShowCount.text = "\(profileData[0].noShow) 次"
        joinCount.text = "\(profileData[0].joinCount) 次"
    }

}
