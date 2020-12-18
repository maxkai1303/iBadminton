//
//  InProfileViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/11/30.
//  swiftlint:disable all

import UIKit
import Eureka
import Firebase

class InProfileViewController: FormViewController  {
    
    //    func receiveData(data: String) {
    //        userName = data
    //        getTeamManber(userId: userId) { teamID in
    //            self.joinTeam.append(teamID)
    //        }
    //
    //        getJoinEvent(userId: userId) { [weak self] event in
    //            self?.joinEvent.append(event["teamID"] as! String)
    //            guard let dateString = self?.timeStampToStringDetail(event["dateStart"] as! Timestamp) else { return }
    //            self?.eventDate.append(dateString)
    //        }
    //
    ////        self.form.allRows.forEach({$0.updateCell(); $0.reload()})
    //    }
    
    var joinTeam: [String] = []
    var joinEvent: [String] = []
    var eventDate: [String] = []
    var userId: String = ""
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        getData()
    }
    
    // MARK: User 還沒抓
    func getData() {
        getTeamManber(userId: userId) { teamID in
            self.joinTeam.append(teamID)
        }
        
        getJoinEvent(userId: userId) { [weak self] event in
            self?.joinEvent.append(event["teamID"] as! String)
            guard let dateString = self?.timeStampToStringDetail(event["dateStart"] as! Timestamp) else { return }
            self?.eventDate.append(dateString)
        }
        
    }
    
    func setLabel() {
        
        tableView.backgroundColor = UIColor.maxColor(with: .lightBlue)
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 12)
        }
        
        form +++ Section()
            <<< SegmentedRow<String>("segments"){
                $0.options = ["參加的球隊", "活動歷史"]
                $0.value = "活動歷史"
                $0.cell.backgroundColor = UIColor(named: "LightBlue")
            }.onChange({ (segmented) in
                if(segmented.value != "參加的球隊") {
                    segmented.section!.removeLast(segmented.section!.count - 1)
                    // MARK: 離開球隊進入球隊都要重新開啟APP才會顯示
                    for value in self.joinTeam {
                        segmented.section! <<< LabelRow() {
                            $0.title = value
                            $0.hidden = "$segments != '參加的球隊'"
                            let deleteAction = SwipeAction(style: .destructive, title: "退出球隊", handler: { (action, row, completionHandler) in
                                
//                               let  FireBaseManager.shared.getCollection(name: .team).document(value)
//                                要再找一個方法確認他是不是唯一的 admin
                                let controller = UIAlertController(title: "哎呦喂呀！", message: "確定要離開球隊嗎", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "離開", style: .destructive, handler: {_ in
                                    print("Delete")
                                    
                                    FireBaseManager.shared.getCollection(name: .team).document(value).updateData([
                                        "teamMenber": FieldValue.arrayRemove([self.userId])
                                    ])
                                    FireBaseManager.shared.getUserName(userId: self.userId) { (result) in
                                        guard result != "" else { return }
                                        self.userName = result!
                                    }
                                    FireBaseManager.shared.addTimeline(team: value, content: "\(self.userName) 離開了球隊", event: false)
                                    completionHandler?(true)
                                    self.getData()
                                    segmented.reload()
                                })
                                let backAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                controller.addAction(backAction)
                                controller.addAction(okAction)
                                self.present(controller, animated: true, completion: nil)
                                
                            })
                            $0.trailingSwipe.actions = [deleteAction]
                            $0.trailingSwipe.performsFirstActionWithFullSwipe = true
                            
                            if #available(iOS 11,*) {
                                let infoAction = SwipeAction(style: .normal, title: "Info", handler: { (action, row, completionHandler) in
                                    print("Info")
                                    completionHandler?(true)
                                })
                                infoAction.actionBackgroundColor = .blue
                                
                                $0.leadingSwipe.actions = [infoAction]
                                $0.leadingSwipe.performsFirstActionWithFullSwipe = true
                            }
                        }.onCellSelection({ cell, row in
                            row.reload()
                        })
                    }
                }
                if(segmented.value != "活動歷史") {
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
    
    func cantLeave() {
        let controller = UIAlertController(
            title: "哎呦喂呀！",
            message: "球隊只有你是管理員無法退出",
            preferredStyle: .alert
        )

        let backAction = UIAlertAction(title: "返回", style: .default) { _ in }
        controller.addAction(backAction)
        self.present(controller, animated: true, completion: nil)
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

