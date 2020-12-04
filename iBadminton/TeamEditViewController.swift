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
            +++ Section("球隊成員")
            <<< PushRow<String>(){ row in
                row.selectorTitle = "球隊成員"
                row.options = ["高麗菜", "高級玩家"]
            }
            .cellUpdate { cell, row in
                cell.accessoryView?.layer.cornerRadius = 17
                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            }
            +++
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "球隊管理者",
                               footer: "刪除管理者後該成員不會被踢出球隊，只有移除管理球隊功能") {
                $0.tag = "options"
                $0.multivaluedRowToInsertAt = { index in
                    return ActionSheetRow<String>{
                        $0.title = "點擊選擇管理員"
                        $0.options = ["二叔公", "小阿姨", "老蔡"]
                    }
                }
                $0 <<< ActionSheetRow<String> {
                    $0.title = "點擊新增"
                    $0.options = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
                }
            }
    }
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
