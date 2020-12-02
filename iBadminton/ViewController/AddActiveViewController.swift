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
    
    var placeMark: CLPlacemark?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
    }
    
    func setTable() {
        
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
                $0.placeholder = "請輸入打球地點"
                //                $0.value = placeMark
            }
            +++ Section("球場環境")
            <<< MultipleSelectorRow<String>() {
                $0.title = "硬體設施"
                $0.selectorTitle = "選擇設備"
                $0.options = ["停車場","淋浴間","飲水機","PU地板","木質地板","冷氣","側燈","頂燈","廁所"]
            }
//            .onPresent { from, to in
//                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(TeamEditViewController.multipleSelectorDone(_:)))
//            }
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
}


