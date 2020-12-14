//
//  CreateTeamViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/14.
//  swiftlint:disable all

import UIKit
import Eureka
import ImageRow

class CreateTeamViewController: FormViewController {
    
    var uploadImage = UIImage()
    var teamId: String = ""
    var teamMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        // Do any additional setup after loading the view.
    }
    
    func setLabel() {
        
        form +++ Section("創建球隊")
            
            <<< TextRow() {
                $0.title = ""
                $0.placeholder = "輸入球隊名稱"
                $0.add(rule: RuleRequired())
            }.cellUpdate { cell, row in
                if !row.isValid {
                    row.placeholder = "此為必填項目"
                    cell.textLabel?.textColor = .systemRed
                }
            }
            
            <<< TextAreaRow { row in
                row.title = "Note"
                row.placeholder = "輸入球隊資訊"
                row.add(rule: RuleMinLength(minLength: 10))
                row.add(rule: RuleMaxLength(maxLength: 250))
            }.cellUpdate { cell, row in
                if !row.isValid {
                    row.placeholder = "此為必填項目最少2字最多12字"
                    cell.textLabel?.textColor = .systemRed
                }
            }
            
            +++ Section("上傳球隊圖片")
            <<< ImageRow() {
                $0.title = "請上傳照片"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
            }.onChange({ (row) in
                self.uploadImage = row.value!
                print("=====\(String(describing: row.value))")
            })
            <<< ButtonRow() {
                $0.title = "創建球隊"
                $0.cellSetup { cell, row in
                    cell.backgroundColor = UIColor(named: "MainBule")
                }.onCellSelection { cell, row in
                    row.section?.form?.validate()
                    print(self.form.values())
                    //                    FireBaseManager.shared.addEvent(collectionName: .event, handler: <#() -> Void#>)
                }
            }
    }
}
