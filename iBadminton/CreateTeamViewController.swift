//
//  CreateTeamViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/14.
//  swiftlint:disable all

import UIKit
import Eureka
import ImageRow
import Firebase

class CreateTeamViewController: FormViewController {
    
    var uploadImage = UIImage()
    var teamId: String = ""
    var teamMessage: String = ""
    var userId: String = ""
    var userName: String = ""
    var adminId: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabel()
        getName()
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
            }
            .cellUpdate({ (cell, row) in
                if let teamRow: TextRow = self.form.rowBy(tag: "teamName"),
                   let value = teamRow.value {
                    self.teamId = value
                }
            })
            
            <<< TextAreaRow { row in
                row.tag = "teamMessage"
                row.placeholder = "輸入球隊資訊"
                row.add(rule: RuleMinLength(minLength: 2))
                row.add(rule: RuleMaxLength(maxLength: 250))
                row.validationOptions = .validatesOnChangeAfterBlurred
            }
            .onRowValidationChanged { cell, row in
                
                if !row.isValid {
                    
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
            }
            .onChange({ row in
                
                print(self.teamMessage)
                
                if let messageRow: TextRow = self.form.rowBy(tag: "teamMessage"),
                   let value = messageRow.value {
                    
                    self.teamMessage = value
                }
            })
            
            +++ Section("上傳球隊圖片")
            <<< ImageRow() {
                $0.title = "請上傳照片（必填）"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            .onChange({ (row) in
                self.uploadImage = row.value ?? UIImage()

                print(self.uploadImage)
            })
            
            <<< ButtonRow() {
                $0.title = "創建球隊"
                $0.cellSetup { cell, row in
                    cell.backgroundColor = UIColor(named: "MainBule")
                }
                .onCellSelection {_, row in
                    
                    row.section?.form?.validate()
                    self.checkRule()
                    
                }
            }
    }
    
    func failAlert() {
        
        let controller = UIAlertController(title: "哎呦喂呀！", message: "請填入完整資訊再送出", preferredStyle: .alert)
        let backAction = UIAlertAction(title: "返回", style: .default, handler: nil)
        
        controller.addAction(backAction)
        self.present(controller, animated: true, completion: nil)
    }
    func checkRule() {
        
        let allValues = self.form.values()
        let name = allValues["teamName"] as? String
        let msg = allValues["teamMessage"] as? String
        
        if  name == nil || msg == nil || uploadImage == UIImage() {
            
            failAlert()
            
        } else {
            
            let controller = UIAlertController(title: "Success！", message: "創建成功", preferredStyle: .alert)
            
            let backAction = UIAlertAction(title: "返回", style: .default) {_ in
                self.form.removeAll()
                self.setLabel()
            }
            
            controller.addAction(backAction)
            self.present(controller, animated: true, completion: nil)
            adminId.append(userId)
            
            getUrl(id: name!) { (result) in
                
                FireBaseManager.shared.addNewTeam(admin: self.adminId,
                                                  image: result,
                                                  menber: [self.userId],
                                                  message: msg!,
                                                  teamName: name!) { id in
                    
                    FireBaseManager.shared.addTimeline(teamDoc: id,
                                                       content: "\(self.userName) 創建了 \(name!) 球隊",
                                                       event: false)
                    print(self.uploadImage)
                    print("================\(allValues)===================")
                }
            }
        }
    }
    
    func getUrl(id: String, handler: @escaping (String) -> Void) {
        
        FirebaseStorageManager.shared.uploadImage(image: self.uploadImage, folder: .team, id: id) { (result) in
            
            switch result {
            
            case.success(let image):
                handler(image)
                
            case.failure(let error):
                print("Upload image fail, error \(error)")
            }
        }
    }
}
