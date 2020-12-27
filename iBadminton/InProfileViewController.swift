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
    
    var joinTeam: [String] = []
    var joinEvent: [String] = []
    var eventDate: [String] = []
    var userId: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        listen()
    }
    
    func listen() {
        guard let user = Auth.auth().currentUser else { return }
        userId = user.uid
        
        FireBaseManager.shared.listen(collectionName: .event) {
            self.joinEvent = []
            self.getJoinEvent(userId: self.userId) { [weak self] event in
                self!.joinEvent.append(event["teamName"] as! String)
                guard let dateString = self?.timeStampToStringDetail(event["dateStart"] as! Timestamp) else { return }
                self!.eventDate.append(dateString)
            }
        }
        FireBaseManager.shared.listen(collectionName: .team) {
            self.joinTeam = []
            self.getTeamManber(userId: self.userId) { teamName in
                for team in teamName {
                    self.joinTeam.append(team.teamName)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    
    func setLabel() {
        
        tableView.backgroundColor = UIColor.maxColor(with: .lightBlue)
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 12)
        }
        
        form +++ Section()
            <<< SegmentedRow<String>("segments"){
                $0.options = ["參加的球隊", "活動歷史"]
                $0.value = ""
                $0.cell.backgroundColor = UIColor(named: "LightBlue")
            }.onChange({ (segmented) in
                if(segmented.value == "參加的球隊") {
                    segmented.section!.removeLast(segmented.section!.count - 1)
                    var teamId: String = ""
                    var userName: String = ""
                    for value in self.joinTeam {
                        segmented.section! <<< LabelRow() {
                            $0.title = value
                            $0.hidden = "$segments != '參加的球隊'"
                            let deleteAction = SwipeAction(style: .destructive, title: "退出球隊", handler: { (action, row, completionHandler) in
                                FireBaseManager.shared.getCollection(name: .team).whereField("teamName", isEqualTo: value) .getDocuments { (querySnapshot, error) in
                                    if let error = error {
                                        print(error)
                                    } else {
                                        var datas = [Team]()
                                        
                                        for document in querySnapshot!.documents {
                                            if let data = try? document.data(as: Team.self, decoder: Firestore.Decoder()) {
                                                datas.append(data)
                                            }
                                        }
                                        
                                        print(datas)
                                        
                                        datas.forEach {
                                            teamId = $0.teamID

                                            FireBaseManager.shared.getCollection(name: .team).document(teamId).getDocument { (document, error) in
                                                if let document = document {
                                                    let onlyAdmin = document["adminID"] as? [String] ?? []
                                                    
                                                    if onlyAdmin.count == 1 && onlyAdmin.contains(self.userId) {
                                                        self.cantLeave()
                                                        return
                                                    }

                                                    let controller = UIAlertController(title: "哎呦喂呀！", message: "確定要離開球隊嗎", preferredStyle: .alert)
                                                    
                                                    let okAction = UIAlertAction(title: "離開", style: .destructive, handler: {_ in
                                                        
                                                        print("Delete")
                                                        
                                                        FireBaseManager.shared.getCollection(name: .team).document(teamId).updateData([
                                                            "teamMenber": FieldValue.arrayRemove([self.userId]),
                                                            "adminID": FieldValue.arrayRemove([self.userId])
                                                        ])
                                                        FireBaseManager.shared.getUserName(userId: self.userId) { (name) in
                                                            guard let name = name, !name.isEmpty else { return }
                                                            userName = name
                                                            FireBaseManager.shared.addTimeline(teamDoc: teamId, content: "\(userName) 離開了球隊", event: false)
                                                        }
                                                        completionHandler?(true)
                                                        row.reload()
                                                        segmented.reload()
                                                    })
                                                    let backAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                                    controller.addAction(backAction)
                                                    controller.addAction(okAction)
                                                    self.present(controller, animated: true, completion: nil)
                                                }
                                            }
                                        }
                                        
                                    }

                                }
                                
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
                        }
                    }
                }
                if(segmented.value == "活動歷史") {
                    
                    segmented.section!.removeLast(segmented.section!.count - 1)
                    
                    guard self.joinEvent != [] else {
                        print("No join Event")
                        return
                    }
                    segmented.section! <<< LabelRow() {
                        $0.title = "已參加 \(self.joinEvent.count) 次活動"
                        
                    }.cellUpdate({ (cell, row) in
//                        cell.tintColor = UIColor.maxColor(with: .mainBlue)
                        cell.textLabel?.textColor = UIColor.maxColor(with: .mainBlue)
                        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//                        cell.detailTextLabel?.textColor = .green
                        
                    })
                    
                    for (name, date) in zip(self.joinEvent, self.eventDate) {
                        segmented.section! <<< LabelRow {
                            $0.title = name
                            $0.cellStyle = .subtitle
                        }.cellUpdate { (cell, row) in
                            cell.detailTextLabel?.text = date
                            cell.detailTextLabel?.textColor = .lightGray
                            row.hidden = "$segments != '活動歷史'"

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
    
    func getTeamManber(userId: String, completion: @escaping ([Team]) -> Void) {
        
        FireBaseManager.shared.getCollection(name:.team).whereField("teamMenber",
                                                                    arrayContains: userId
        ).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                FireBaseManager.shared.decode(Team.self, documents: querySnapshot!.documents) { (result) in
                    
                    switch result {
                    
                    case .success(let data):
                        
                        completion(data)
                        
                    case .failure(let error):
                    
                        print(error)
                    }
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
    
    @objc(tableView:accessoryButtonTappedForRowWithIndexPath:) func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
    }
    
}

