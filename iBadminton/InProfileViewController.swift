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
        
        form = Section()
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
                
            }

            <<< LabelRow(){
                $0.title = "羽龍共舞"
            }
            <<< LabelRow(){
                $0.title = "南無阿密陀佛"
            }
            <<< LabelRow(){
                $0.title = "今日躲雨"
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

