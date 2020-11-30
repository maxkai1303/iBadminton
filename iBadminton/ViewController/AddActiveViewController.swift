//
//  AddActiveViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//  swiftlint:disable all

import UIKit
import Eureka
import ImageRow
import LocationRow
import MapKit
import CoreLocation

class AddActiveViewController: FormViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("活動資訊")
            <<< IntRow(){
                $0.title = "需求人數"
                $0.placeholder = "Enter Number of people"
            }
            <<< DateTimeInlineRow(){
                $0.title = "打球日期時間"
                $0.value = Date()
            }
            <<< TextRow(){ row in
                row.title = "使用球種"
                row.placeholder = "Enter text here"
            }
            <<< LocationRow(){
                $0.title = "LocationRow"
                $0.value = CLLocation(latitude: -34.9124, longitude: -56.1594)
                
            }
            +++ Section("球場環境")
            <<< MultipleSelectorRow<String>() {
                $0.title = "硬體設施"
                $0.selectorTitle = "選擇設備"
                $0.options = ["停車場","淋浴間","飲水機","PU地板","木質地板","冷氣","側燈","頂燈","廁所"]
            }.onPresent { from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(TeamEditViewController.multipleSelectorDone(_:)))
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


