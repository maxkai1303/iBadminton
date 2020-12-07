//
//  InProfileViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//  swiftlint:disable all

import UIKit
import Eureka

class InProfileViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(named: "LightBlue")
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 12)
        }
        
        form = Section("點擊切換顯示")
            <<< SegmentedRow<String>("segments"){
                $0.options = ["參加的球隊", "活動歷史"]
                $0.value = "Films"
            }
            +++ Section(){
                $0.tag = "team"
                $0.hidden = "$segments != '參加的球隊'"
            }
            <<< LabelRow(){
                $0.title = "地方媽媽愛打球什麼球都打"
            }

            <<< LabelRow(){
                $0.title = "乃木坂賽高"
            }

            <<< LabelRow(){
                $0.title = "羽龍共舞"
                
            }

            +++ Section(){
                $0.tag = "active"
                $0.hidden = "$segments != '活動歷史'"
            }
            <<< LabelRow(){
                $0.title = "羽龍共舞"
                $0.value = "2020/12/16"
            }
            <<< ButtonRow() {
                $0.title = "前往評價"
            }

            <<< LabelRow(){
                $0.title = "羽龍共舞"
                $0.value = "2020/12/12"
            }
            <<< LabelRow(){
                $0.title = "南無阿密陀佛"
                $0.value = "2020/11/15"
            }
            <<< LabelRow(){
                $0.title = "今日躲雨"
                $0.value = "2020/11/03"
            }

//
//            +++ Section(){
//                $0.tag = "films_s"
//                $0.hidden = "$segments != 'Films'"
//            }
//            <<< TextRow(){
//                $0.title = "Which is your favourite actor?"
//            }
//
//            <<< TextRow(){
//                $0.title = "Which is your favourite film?"
//            }
        
//        form +++ Section("參加的球隊")
//            <<< LabelRow(){ row in
//                row.title = "地方媽媽愛打球什麼球都打"
//            }
//            <<< LabelRow(){ row in
//                row.title = "乃木坂才是最棒的偶像"
//            }
//            <<< LabelRow(){ row in
//                row.title = "羽龍共舞"
//            }
//            +++ Section("活動歷史")
//            <<< DateRow(){
//                $0.title = "Date Row"
//                $0.value = Date(timeIntervalSinceReferenceDate: 0)
//            }
    }
}

