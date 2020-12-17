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
    var image = UIImage()
    var startDate = Date()
    var endDate = Date()
    var location: CLPlacemark?
    var ownTeam: [String] = []
    var tag: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        getTeam()
    }
    // MARK: 需要拿到擁有的球隊
    func getTeam() {
    }
    
    
    func setTable() {
        
        form +++ Section("輸入活動資訊")
            
            <<< PickerInputRow<String>("Picker Input Row"){
                $0.title = "活動球隊"
                $0.options = []
                for i in 1...10{
                    $0.options.append("option \(i)")
                }
                $0.value = $0.options.first
            }.onChange({ (row) in
                self.pickerTeam = row.value!
                print("value changed: \(row.value!)")
            })
            
            <<< IntRow(){
                $0.title = "需求人數"
                $0.placeholder = "Enter Number of people"
                // MARK: 記得最後要修改成 1
                $0.add(rule: RuleGreaterThan(min: 2))
            }.onChange({ (row) in
                self.people = row.value ?? 1
                print("======value changed: \(row.value ?? 1)=====")
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
            
            <<< TextRow(){ row in
                row.title = "使用球種"
                row.placeholder = "Enter text here"
            }.onChange({ (row) in
                self.ball = row.value ?? ""
                print("======value changed: \(row.value ?? "")=====")
            }).onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
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
            }
            
            <<< LocationRow(){
                $0.placeholder = "請輸入打球地點"
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.tintColor = .red
                }
            }.onChange({ (row) in
                self.location = row.value
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
                $0.title = "請上傳照片 1"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
            }.onChange({ (row) in
                self.image = row.value ?? UIImage()
                print("=====\(String(describing: row.value))")
            })
            
            <<< ImageRow() { row in
                row.title = "請上傳照片 2（選填）"
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.clearAction = .yes(style: .default)
            }
            
            <<< ImageRow() {
                $0.title = "請上傳照片 3（選填）"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
            }
            
            <<< ImageRow() {
                $0.title = "請上傳照片 4（選填）"
                $0.sourceTypes = [.PhotoLibrary, .Camera]
                $0.clearAction = .yes(style: .default)
            }
            +++ Section()
            <<< ButtonRow() {
                $0.title = "新增活動"
                $0.cellSetup { cell, row in
                    cell.backgroundColor = UIColor(named: "MainBule")
                }.onCellSelection { cell, row in
                    row.section?.form?.validate()
                    self.dismiss(animated: true, completion: nil)
                    self.form.removeAll()
                    self.setTable()
                    //                    FireBaseManager.shared.addEvent(collectionName: .event, handler: <#() -> Void#>)
                }
            }
    }
    
    
    
    //    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    //
    //        let locale = Locale(identifier: "zh_TW")
    //        let loc: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
    //            CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: locale) { placemarks, error in
    //                guard let placemark = placemarks?.first, error == nil else {
    //                    UserDefaults.standard.removeObject(forKey: "AppleLanguages")
    //                    completion(nil, error)
    //                    return
    //                }
    //                completion(placemark, nil)
    //            }
    //    }
    //
    //    func locationAddress(){
    //        // CLGeocoder地理編碼 經緯度轉換地址位置
    //        geocode(latitude: 24.12721655694024, longitude: 120.6682352929325) { placemark, error in
    //            guard let placemark = placemark, error == nil else { return }
    //            DispatchQueue.main.async {
    //                print("address1:", placemark.thoroughfare ?? "")
    //                print("address2:", placemark.subThoroughfare ?? "")
    //                print("city:",     placemark.locality ?? "")
    //                print("state:",    placemark.administrativeArea ?? "")
    //                print("zip code:", placemark.postalCode ?? "")
    //                print("country:",  placemark.country ?? "")
    //                print("placemark",placemark)
    //                self.placeMark = placemark
    //            }
    //        }
    //    }
    
    @objc func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}


