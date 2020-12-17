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
    
    //    var placeMark: CLPlacemark?
    var userId: String = ""
    var userName: String = ""
    var pickerTeam: String = ""
    var people: Int = 0
    var ball: String = ""
    var image: [UIImage] = []
    var startDate = Date()
    var endDate = Date()
    var location: String = ""
    var ownTeam: [Team] = []
    var tag: [String] = []
    var level: String = ""
    var price: Int = 0
    var note: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        
    }
    
    
    func setTable() {
        
        form +++ Section("輸入活動資訊")
            
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
            }.onChange({ (row) in
                self.pickerTeam = row.value!
                print("value changed: \(row.value!)")
            })
            
            <<< TextRow(){ row in
                row.title = "使用球"
                row.placeholder = "非必填項目"
            }.onChange({ (row) in
                self.ball = row.value ?? ""
                print("======value changed: \(row.value ?? "")=====")
            }).onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
            }
            
            <<< IntRow(){
                $0.title = "需求人數"
                $0.placeholder = "Enter Number of people"
                // MARK: 記得最後要修改成 1
                $0.add(rule: RuleGreaterThan(min: 2))
            }.onChange({ (row) in
                self.people = row.value ?? 0
                print("======value changed: \(row.value ?? 0)=====")
            })
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = "請輸入最少 1 人"
                            $0.cell.height = { 30 }
                            $0.cell.backgroundColor = .red
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
            }
            
            <<< IntRow(){
                $0.title = "零打價錢"
                $0.placeholder = "Enter price"
                $0.add(rule: RuleRequired())
            }.onChange({ (row) in
                self.price = row.value ?? 0
                print("======value changed: \(row.value ?? 0)=====")
            })
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = "此為必填項目不得為 0"
                            $0.cell.height = { 30 }
                            $0.cell.backgroundColor = .red
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
            }
            
            <<< DateTimeInlineRow(){
                $0.title = "開始時間"
                $0.value = Date()
            }.onChange({ row in
                self.startDate = row.value!
                print(self.startDate)
            })
            
            <<< DateTimeInlineRow(){
                $0.title = "結束時間"
                $0.value = Date()
            }.onChange({ row in
                self.endDate = row.value!
                print(self.endDate)
            })
            
            <<< DoublePickerInlineRow<String, String>() {
                $0.title = "選擇程度"
                $0.firstOptions = { return ["初", "初中", "初上", "中", "中下", "中上", "高"]}
                $0.secondOptions = { _ in return ["初", "初中", "初上", "中", "中下", "中上", "高"]}
                $0.displayValueFor = {
                    guard let pick = $0 else { return nil }
                    self.level = "\(pick.a + "-" + pick.b)"
                    return pick.a + "-" + pick.b
                }
            }
            
            <<< LocationRow(){
                $0.placeholder = "請輸入打球地點"
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.tintColor = .red
                }
            }.onChange({ (row) in
                self.location = "\(String(describing: row.value))"
                //                print("======value changed: \(row.value)=====")
            })
            
            
            +++ Section("球場環境")
            <<< MultipleSelectorRow<String>() {
                $0.title = "硬體設施"
                $0.selectorTitle = "選擇設備"
                $0.options = ["停車場","淋浴間","飲水機","PU地板","木質地板","冷氣","側燈","頂燈","廁所"]
            }.onPresent { from, to in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(AddActiveViewController.multipleSelectorDone(_:)))
            }.onChange({ (row) in
                if let item = row.value {
                    if self.tag.count >= 1 {
                        self.tag = []
                        self.tag.append(contentsOf: item)
                    } else {
                        self.tag.append(contentsOf: item)
                    }
                }
                print(self.tag)
            })
            
            
            +++ Section("上傳照片")
            <<< ImageRow() {
                $0.title = "請上傳照片（必填）"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }.onChange({ (row) in
                self.image.append(row.value ?? UIImage())
                print("=====\(String(describing: row.value))")
            })
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
            
            <<< ImageRow() { row in
                row.title = "請上傳照片 2（選填）"
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.clearAction = .yes(style: .default)
            }.onChange({ (row) in
                self.image.append(row.value ?? UIImage())
            })
            
            <<< ImageRow() {
                $0.title = "請上傳照片 3（選填）"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
            }.onChange({ (row) in
                self.image.append(row.value ?? UIImage())
            })
            
            <<< ImageRow() {
                $0.title = "請上傳照片 4（選填）"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
            }.onChange({ (row) in
                self.image.append(row.value ?? UIImage())
            })
            
            <<< TextAreaRow() {
                $0.title = "活動其他資訊"
                $0.placeholder = "最多輸入兩百字"
                //                $0.add(rule: <#T##RuleType#>)  記得設定最多200字
                $0.validationOptions = .validatesOnChange
            }
            // 記得寫一個獲得文字的方法
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "新增活動"
                $0.cellSetup { cell, row in
                    cell.backgroundColor = UIColor(named: "MainBule")
                }.onCellSelection { [self] cell, row in
                    row.section?.form?.validate()
                    print("~~~~~~~~~~~~~\(form.values())~~~~~~~~~~~")
                    guard people != 0 else {
                        showFailAlert(message: "請輸入需求人數")
                        return
                    }
                    guard level == "" else {
                        showFailAlert(message: "請選擇招募程度")
                        return
                    }
                    guard location == "" else {
                        showFailAlert(message: "請輸入活動地點")
                        return
                    }
                    guard image.isEmpty == true else {
                        showFailAlert(message: "請至少上傳一張照片")
                        return
                    }
                    showSucessAlert()
                }
            }
    }
    
    func showFailAlert(message: String) {
        let controller = UIAlertController(title: "哎呦喂呀！", message: message, preferredStyle: .alert)
        let backAction = UIAlertAction(title: "返回", style: .default, handler: nil)
        controller.addAction(backAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func showSucessAlert() {
        let controller = UIAlertController(title: "Sucess！", message: "新增成功", preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "完成", style: .default) {_ in
            
            for i in self.image {
                
            }
            
            let addEvent = Event(
                ball: ball,
                dateStart: startDate,
                dateEnd: endDate,
                eventID: eventId,
                image: <#T##[String]#>,
                joinID: [userId],
                lackCount: people,
                level: level,
                location: location,
                price: price,
                status: true,
                teamID: pickerTeam,
                tag: tag,
                note: note)
            
            FireBaseManager.shared.addEvent(collectionName: .event, event: addEvent) {
                
            }
            
            self.form.removeAll()
            self.setTable()
        }
        controller.addAction(backAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func getUrl(id: String, handler: @escaping ([String]) -> Void) {
        var urls: [String] = []
        let doc = FireBaseManager.shared.getCollection(name: .event).document()
        let eventId = doc.documentID
        
        
        for i in image {
            
            FirebaseStorageManager.shared.uploadImage(image: i, folder: .event, id: eventId) { (result) in
                switch result {
                
                case .success(let url):
                    
                    urls.append(url)
                    if urls.count == self.image.count {
                        
                        handler(urls)
                    }
                case .failure(let error):
                    
                    print("upload image fail, error:", error.localizedDescription)
                }
            }
        }
    }
    
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}


