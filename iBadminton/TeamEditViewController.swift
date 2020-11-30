//
//  TeamEditViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/29.
//  swiftlint:disable all

import UIKit
import Eureka
import ImageRow

class TeamEditViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("球隊基本資料")
            <<< TextRow(){ row in
                row.title = "球隊名稱"
                row.placeholder = "Enter text here"
            }
            +++ Section("球隊訊息")
            <<< TextAreaRow(){ row in
                row.title = "Note"
                row.placeholder = "Enter text here"
            }
            
            .cellUpdate { cell, row in
                cell.accessoryView?.layer.cornerRadius = 17
                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            }
    }
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

}
