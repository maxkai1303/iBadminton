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
            <<< IntRow(){
                $0.title = "需求人數"
                $0.placeholder = "And numbers here"
            }
            <<< DateRow(){
                $0.title = "打球日期"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
            <<< TextRow(){ row in
                row.title = "使用球種"
                row.placeholder = "Enter text here"
            }
            +++ Section("球隊訊息")
            <<< TextRow(){ row in
                row.title = "Note"
                row.placeholder = "Enter text here"
            }
            +++ Section("球場環境")
            <<< MultipleSelectorRow<String>() {
                $0.title = "硬體設施"
                $0.selectorTitle = "選擇設備"
                $0.options = ["停車場","淋浴間","飲水機","PU地板","木質地板","冷氣","側燈","頂燈","廁所"]
            }
            +++ Section("上傳照片")
            <<< ImageRow() { row in
                row.title = "Image Row 1"
                row.sourceTypes = .PhotoLibrary
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
            }
            <<< ImageRow() {
                $0.title = "Image Row 2"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
            }
            .cellUpdate { cell, row in
                cell.accessoryView?.layer.cornerRadius = 17
                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            }
    }
}
