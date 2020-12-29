//
//  PrivacyPolicyViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/29.
//  swiftlint:disable all

import UIKit
import Eureka

class PrivacyPolicyViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        privacy()
    }
    
    func privacy() {
        
        form = Section()
            <<< SegmentedRow<String>("segments"){
                $0.options = ["隱私權政策", "PrivacyPolicy"]
                $0.value = "PrivacyPolicy"
            }
        
            +++ Section(){
                $0.tag = "PrivacyEn"
                $0.hidden = "$segments != 'PrivacyPolicy'"
            }
            <<< TextAreaRow(){
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 300)
                $0.textAreaMode = .readOnly
                $0.value = Bundle.main.object(forInfoDictionaryKey: "Privacy Policy En") as? String
            }
            .cellSetup({ (cell, row) in
                cell.textView.font = UIFont(name: "PingFangTC-Regular", size: 12)
            })
        
            +++ Section(){
                $0.tag = "PrivacyZh"
                $0.hidden = "$segments != '隱私權政策'"
            }
            <<< TextAreaRow(){
                
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 300)
                $0.textAreaMode = .readOnly
                $0.value = Bundle.main.object(forInfoDictionaryKey: "Privacy Policy Zh") as? String
            }
            .cellSetup({ (cell, row) in
                cell.textView.font = UIFont(name: "PingFangTC-Regular", size: 12)
            })
        
    }
   
}
