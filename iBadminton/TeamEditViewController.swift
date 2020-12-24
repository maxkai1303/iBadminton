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
    var teamMember: [String] = []
    var selectTeam: Team? {
        didSet {
            FireBaseManager.shared.getOwnTeam(userId: userId) { (result) in
                self.ownTeam = result
            }
            self.form.allRows.forEach({ $0.updateCell(); $0.reload()})
            tableView.reloadData()
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
            
        form +++ Section("修改球隊顯示內容")
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
        
            +++ Section(header: "選擇球隊後點擊切換刷新顯示", footer: "管理員左滑移除刪除\n管理者後該成員不會被踢出球隊，只有移除管理球隊功能\n隊員右滑加入管理員")
                <<< SegmentedRow<String>("segments"){
                    $0.options = ["球隊管理員", "球隊隊員名單"]
                    $0.value = ""
                    $0.cell.backgroundColor = .groupTableViewBackground
                    $0.cell.layer.borderWidth = 0
                    //                $0.baseCell.layer.borderWidth = 0
                }.onChange({ (segmented) in
                    if(segmented.value == "球隊管理員") {
                        segmented.section!.removeLast(segmented.section!.count - 1)
                        guard let admind = self.selectTeam?.adminID else { return }
                        for i in admind {
                            FireBaseManager.shared.getUserName(userId: i) { (name) in
                                segmented.section! <<< LabelRow() {
                                    $0.title = name
                                    $0.hidden = "$segments != '球隊管理員'"
                                    
                                        let deleteAction = SwipeAction(style: .destructive, title: "移除管理員", handler: { (action, row, completionHandler) in
                                            
                                            guard i != self.userId && admind.count != 1 else {
                                                self.cantLeave()
                                                return
                                            }
                                            
                                            let controller = UIAlertController(title: "哎呦喂呀！", message: "確定要移除這位管理員嗎", preferredStyle: .alert)
                                            
                                            let okAction = UIAlertAction(title: "移除", style: .destructive, handler: {_ in
                                                
                                                print("Delete")
                                                guard let teamId = self.selectTeam?.teamID else { return }
                                                FireBaseManager.shared.getCollection(name: .team).document(teamId).updateData([
                                                    "adminID": FieldValue.arrayRemove([i])
                                                ])
                                                FireBaseManager.shared.addTimeline(teamDoc: teamId, content: "\(name!) 解除管理員", event: false)
                                                completionHandler?(true)
                                                
                                            })
                                            let backAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                            controller.addAction(backAction)
                                            controller.addAction(okAction)
                                            self.present(controller, animated: true, completion: nil)
                                            
                                        })
                                        $0.trailingSwipe.actions = [deleteAction]
                                        $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                                    
                                }
                            }
                        }
                    } else if (segmented.value == "球隊隊員名單") {
                        segmented.section!.removeLast(segmented.section!.count - 1)
                        guard let member = self.selectTeam?.teamMenber else { return }
                        self.teamMember = []
                        for i in member {
                            FireBaseManager.shared.getUserName(userId: i) { (name) in
                                segmented.section! <<< LabelRow() {
                                    $0.title = name
                                    $0.hidden = "$segments != '球隊隊員名單'"
                                    self.teamMember.append(name ?? "")
                                }
                            }
                        }
                    }
                }).cellSetup({ (cell, row) in
                    cell.layer.borderWidth = 0
                    cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
                }).cellUpdate({ (cell, row) in
                    row.reload()
                })
    }
    
    func cantLeave() {
        let controller = UIAlertController(
            title: "哎呦喂呀！",
            message: "不能移除自己啦！",
            preferredStyle: .alert
        )
        
        let backAction = UIAlertAction(title: "返回", style: .default) { _ in }
        controller.addAction(backAction)
        self.present(controller, animated: true, completion: nil)
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


