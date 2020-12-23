//
//  TeamEditViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/29.
//  swiftlint:disable all

import UIKit
import Eureka
import ImageRow
import Firebase

class TeamEditViewController: FormViewController {
    
    var userId: String = ""
    var userName: String = ""
    var ownTeam: [Team] = []
    var pickerTeam: String = ""
    var teamImage = UIImage()
    var teamMessage: String = ""
    var teamName: String = ""
    var admindId:[String] = []
    var selectTeam: Team? {
        didSet {
            FireBaseManager.shared.getOwnTeam(userId: userId) { (result) in
                self.ownTeam = result
            }
            self.form.allRows.forEach({ $0.updateCell(); $0.reload()})
//            tableView.reloadData()
        }
    }
    
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
                $0.options = ["請選擇球隊"]
                let teamName = ownTeam.map {
                    return $0.teamName
                }
                for i in teamName {
                    $0.options.append("\(i)")
                }
                $0.value = $0.options.first
                self.pickerTeam = $0.value!
                
            }.onChange({ (row) in
                self.pickerTeam = row.value ?? ""
//                self.form.allRows.forEach({_ in row.updateCell(); row.reload()})
                for team in self.ownTeam where team.teamName == self.pickerTeam {
                    self.selectTeam = team
                }
                row.reload()
                print("value changed: \(row.value!)")
                print(self.selectTeam ?? [])
            })
            
            <<< ImageRow() {
                $0.title = "上傳球隊照片（必填）"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }.onChange({ (row) in
                self.teamImage = row.value!
                print("=====\(String(describing: row.value))")
            })
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
            
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
            
            <<< TextAreaRow(){
                $0.title = "Note"
                $0.placeholder = "介紹一下你的球隊 10 - 200 字"
                $0.add(rule: RuleMinLength(minLength: 10))
                $0.add(rule: RuleMaxLength(maxLength: 200))
                $0.validationOptions = .validatesOnChange
            }.onChange({ row in
                self.teamMessage = row.value ?? ""
            }).cellUpdate { cell, row in
                if !row.isValid {
                    row.placeholder = "最少 10 字最多輸入 200 字"
                    cell.textView.backgroundColor = .systemRed
                }
            }
            
            +++ Section("球隊成員")
            <<< SwitchRow("adminTag"){
                $0.title = "顯示球隊管理者"
            }
            <<< LabelRow(){
                $0.hidden = Condition.function(["adminTag"], { form in
                    return !((form.rowBy(tag: "adminTag") as? SwitchRow)?.value ?? false)
                })
            }.cellUpdate({ cell, row  in

                for i in self.selectTeam!.adminID {
                        FireBaseManager.shared.getUserName(userId: i) { (name) in
                            row.title = name
                        }
                }
            })
    
            
            <<< SwitchRow("manberTag"){
                $0.title = "顯示球隊成員"
            }
            <<< LabelRow(){
                
                $0.hidden = Condition.function(["manberTag"], { form in
                    return !((form.rowBy(tag: "manberTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "item"
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
                        guard row.value != "" else { return }
                        self.admindId.append(row.value!)
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
                    self.getUrl(id: self.pickerTeam) { (result) in
                        
                        let image = result
                        FireBaseManager.shared.getCollection(name:.team).document("\(self.pickerTeam)").updateData([
                            "teamImage": image,
                            "teamMessage": self.teamMessage,
                            "adminID": FieldValue.arrayUnion(self.admindId),
                            "teamID": self.teamName
                        ])
                    }
                    
                    self.showSucessAlert()
                    print("\(self.form.values())")
                }
            }
    }
    
    func showSucessAlert() {
        let controller = UIAlertController(title: "Sucess！", message: "修改成功", preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "完成", style: .default) { (_) in
            self.form.removeAll()
            self.setUi()
        }
        
        controller.addAction(backAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func getUrl(id: String, handler: @escaping (String) -> Void) {
        FirebaseStorageManager.shared.uploadImage(image: self.teamImage, folder: .team, id: id) { (result) in
            switch result {
            case.success(let image):
                handler(image)
            case.failure(let error):
                print("Upload image fail, error \(error)")
            }
        }
    }
    
    @objc func multipleSelectorDone(_ item: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}


