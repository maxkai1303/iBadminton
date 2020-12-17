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
    
    var userId: String = ""
    var userName: String = ""
    var ownTeam: [Team] = []
    var pickerTeam: String = ""
    var teamImage: [String] = []
    var teamMessage: String = ""
    var teamName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
        FireBaseManager.shared.getOwnTeam(userId: userId) { (result) in
            self.ownTeam = result
        }
        
    }
    
    func setUi() {
        
        form +++ Section("選擇修改的球隊")
            
            <<< PickerInputRow<String>("Picker Input Row"){
                $0.title = "活動球隊"
                $0.options = []
                let teamId = ownTeam.map {
                    return $0.teamID
                }
                for i in teamId {
                    $0.options.append("\(i)")
                }
                $0.value = $0.options.first
                self.pickerTeam = $0.value!
            }.onChange({ (row) in
                self.pickerTeam = row.value ?? ""
                print("value changed: \(row.value!)")
            })
            
            +++ Section("修改內容")
            <<< TextRow(){ row in
                row.title = "球隊名稱"
                row.placeholder = "最少2字最多12字"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.add(rule: RuleMinLength(minLength: 2))
                row.add(rule: RuleMaxLength(maxLength: 12))
            }.onChange({ row in
                self.teamName = row.value ?? ""
            }).cellUpdate { cell, row in
                if !row.isValid {
                    row.placeholder = "此為必填項目最少2字最多12字"
                    cell.titleLabel?.textColor = .systemRed
                }
            }
            
            <<< ImageRow() {
                $0.title = "上傳球隊照片"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
            }.onChange({ (row) in
//                self.image = row.value!
                print("=====\(String(describing: row.value))")
            })
            
            +++ Section("球隊訊息")
            <<< TextAreaRow(){ row in
                row.title = "Note"
                row.placeholder = "Enter text here"
            }.onChange({ row in
                self.teamMessage = row.value ?? ""
            })
            
            +++ Section("球隊成員")
            <<< SwitchRow("manberTag"){
                           $0.title = "顯示球隊成員"
                       }
                       <<< LabelRow(){

                           $0.hidden = Condition.function(["manberTag"], { form in
                               return !((form.rowBy(tag: "manberTag") as? SwitchRow)?.value ?? false)
                           })
                            $0.title = "item"
                   }
            <<< SwitchRow("adminTag"){
                           $0.title = "顯示球隊管理者"
                       }
                       <<< LabelRow(){

                           $0.hidden = Condition.function(["adminTag"], { form in
                               return !((form.rowBy(tag: "adminTag") as? SwitchRow)?.value ?? false)
                           })
                            $0.title = "Max"
                   }
            
            +++
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete, .Reorder],
                               header: "球隊管理者",
                               footer: "刪除管理者後該成員不會被踢出球隊，只有移除管理球隊功能") {
                $0.tag = "options"
                $0.multivaluedRowToInsertAt = { index in
                    return ActionSheetRow<String>{
                        $0.title = "新增管理員"
                        $0.options = ["二叔公", "小阿姨", "老蔡"]
                    }.onChange({ row in
                        row.title = "管理員"
                    })
                }
                
            }
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "送出修改"
                }.onCellSelection { cell, row in
                    row.section?.form?.validate()
                    if self.pickerTeam == "" || self.teamName == "" {
                        let controller = UIAlertController(title: "哎呦喂呀！", message: "請修改完整資訊再送出", preferredStyle: .alert)
                        let backAction = UIAlertAction(title: "返回", style: .default, handler: nil)
                        controller.addAction(backAction)
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        self.form.removeAll()
                        self.setUi()
                        print("\(self.form.values())")
                    }
            }
    }
    

    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}


