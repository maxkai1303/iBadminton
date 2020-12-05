//
//  ProfileViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/28.
//  swiftlint:disable all

import UIKit
import Eureka
import FirebaseAuth

class ProfileViewController: FormViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRating: UILabel!
    
    @IBOutlet weak var createTeamOutlet: UIButton!
    @IBOutlet weak var messageOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    

}
