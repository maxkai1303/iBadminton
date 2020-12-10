//
//  InProfileViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//  swiftlint:disable all

import UIKit
import Eureka
import Firebase

class InProfileViewController: FormViewController {
    
    var joinTeam: [String] = []
    var joinEvent: [String] = []
    var eventDate: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        
    }
    
    func setLabel() {
        // MARK: 要從 profile裡面拿到 uid
        getTeamManber(userId: "xJlxfKVWdladCX8vKDWAvr78Xsj1") { teamID in
            self.joinTeam.append(teamID)
        }
        
        getJoinEvent(userId: "xJlxfKVWdladCX8vKDWAvr78Xsj1") { [weak self] event in
            self?.joinEvent.append(event["teamID"] as! String)
            guard let dateString = self?.timeStampToStringDetail(event["dateStart"] as! Timestamp) else { return }
            self?.eventDate.append(dateString)
        }
        
        tableView.backgroundColor = UIColor(named: "LightBlue")
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 12)
        }
        
        form +++ Section()
            <<< SegmentedRow<String>("segments"){
                $0.options = ["參加的球隊", "活動歷史"]
                $0.value = "參加的球隊"
                $0.cell.backgroundColor = UIColor(named: "LightBlue")
            }.onChange({ (segmented) in
                if(segmented.value == "參加的球隊") {
                    
                    segmented.section!.removeLast(segmented.section!.count - 1)
                    
                    for value in self.joinTeam
                    {
                        segmented.section! <<< LabelRow(){
                            $0.title = value
                        }
                    }
                }
                if(segmented.value == "活動歷史") {
                    segmented.section!.removeLast(segmented.section!.count - 1)
                    
                    for value in self.joinEvent {
                        for date in self.eventDate {
                            segmented.section! <<< LabelRow { row in
                                // MARK: 要找收折的方法
                                row.title = value
                                row.value = date
                                row.cell.textLabel?.numberOfLines = 2
                            }
                        }
                    }
                }
            })
    }
    
    func getTeamManber(userId: String, completion: @escaping (String) -> Void) {
        
        FireBaseManager.shared.getCollection(name:.team).whereField("teamMenber",
                                                                    arrayContains: userId
        ).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    completion(document.documentID)
                }
            }
        }
    }
    
    func getJoinEvent(userId: String, completion: @escaping ([String:Any]) -> Void) {
        FireBaseManager.shared.getCollection(name: .event).whereField("joinID",
                                                                      arrayContains: userId
        ).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    completion(document.data())
                    
                }
            }
        }
    }
    
    func timeStampToStringDetail(_ timeStamp: Timestamp) -> String {
        let timeSta = timeStamp.dateValue()
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
        return dfmatter.string(from: timeSta)
      }
    
}

