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
    var userId: String = ""
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }
    func getName() {
        FireBaseManager.shared.getUserName(userId: userId) { (name) in
            guard name != "" else { return }
            self.userName = name!
        }
    }
    
    func setLabel() {
        
        form +++ Section("創建球隊")
            
            <<< TextRow() {
                $0.tag = "teamName"
                $0.title = ""
                $0.placeholder = "輸入球隊名稱"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged { cell, row in
                if !row.isValid {
                    //                    row.placeholder = "此為必填項目"
                    for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = "此項目為必填項目"
                            $0.cell.height = { 30 }
                            $0.cell.backgroundColor = .red
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
                if let teamRow: TextRow = self.form.rowBy(tag: "teamName"), let value = teamRow.value {
                    self.teamId = value
                }
            }
            
            <<< TextAreaRow { row in
                row.tag = "teamMessage"
                row.placeholder = "輸入球隊資訊"
                row.add(rule: RuleMinLength(minLength: 2))
                row.add(rule: RuleMaxLength(maxLength: 250))
                row.validationOptions = .validatesOnChangeAfterBlurred
            }.onRowValidationChanged { cell, row in
                if !row.isValid {
                    //                    row.placeholder = "此為必填項目最少2字最多250字"
                    for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = "此為必填項目最少2字最多250字"
                            $0.cell.height = { 30 }
                            $0.cell.backgroundColor = .red
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
            }.onChange({ row in
                print(self.teamMessage)
                if let messageRow: TextRow = self.form.rowBy(tag: "teamMessage"), let value = messageRow.value {
                    self.teamMessage = value
                }
            })
            
            +++ Section("上傳球隊圖片")
            <<< ImageRow() {
                $0.title = "請上傳照片"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
            }.onChange({ (row) in
                self.uploadImage = row.value!
                print(self.uploadImage)
            })
            
            <<< ButtonRow() {
                $0.title = "創建球隊"
                $0.cellSetup { cell, row in
                    cell.backgroundColor = UIColor(named: "MainBule")
                }.onCellSelection {_, row in
                    row.section?.form?.validate()
                    self.checkRule()
                    
                }
            }
    }
    func checkRule() {
        let allValues = self.form.values()
        let name = allValues["teamName"] as! String
        let msg = allValues["teamMessage"] as! String
        if /*self.uploadImage == nil || */ name == "" || msg == "" {
            let controller = UIAlertController(title: "哎呦喂呀！", message: "請填入完整資訊再送出", preferredStyle: .alert)
            let backAction = UIAlertAction(title: "返回", style: .default, handler: nil)
            controller.addAction(backAction)
            self.present(controller, animated: true, completion: nil)
        } else {
            let controller = UIAlertController(title: "Success！", message: "創建成功", preferredStyle: .alert)
            let backAction = UIAlertAction(title: "返回", style: .default) {_ in
                self.form.removeAll()
                self.setLabel()
            }
            controller.addAction(backAction)
            self.present(controller, animated: true, completion: nil)
            FireBaseManager.shared.addNewTeam(admin: userId, teamId: name, image: "uploadImage", menber: [userId], message: msg)
            FireBaseManager.shared.addTimeline(team: name, content: "\(userName) 創建了球隊", event: false)
            print(self.uploadImage)
            print("================\(allValues)===================")
        }
    }
}
