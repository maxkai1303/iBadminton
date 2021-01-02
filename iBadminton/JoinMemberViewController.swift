//
//  JoinMemberViewController.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/25.
//

import UIKit
import Firebase
import FirebaseAuth

class JoinMemberViewController: UIViewController, UITableViewDelegate {
    
    var memberList: [String] = []
    var eventId: String = ""
    var event: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenEvent()
    }
    
    @IBOutlet weak var joinMemberTabelView: UITableView!
    
    func readEvent() {
        
        FireBaseManager.shared.getCollection(name: .event).document(eventId).getDocument { (document, _) in
            if let document = document {
                guard let data = try? document.data(as: Event.self) else {
                    return
                }
                self.memberList = data.joinID
                self.joinMemberTabelView.reloadData()
            }
        }
    }
    
    func listenEvent() {
        
        FireBaseManager.shared.getCollection(name: .event).document(eventId).addSnapshotListener { documentSnapshot, _ in
            
            guard let doc = documentSnapshot else { return }
            print(doc)
            
            self.readEvent()
        }
    }
    
}

extension JoinMemberViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "joinMemberTableViewCell", for: indexPath)
                as? JoinMemberTableViewCell else { return UITableViewCell() }
        
        cell.setUi(member: memberList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        
        default:
            return "活動參加人員列表"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if editingStyle == .delete {
            
            let controller = UIAlertController(title: "哎呦喂呀！", message: "確定不去打球了嗎", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "先不去了", style: .destructive, handler: {_ in
                
                self.memberList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                FireBaseManager.shared.getCollection(name: .event).document(self.eventId).updateData([
                    
                    "joinID": FieldValue.arrayRemove([user.uid])
                ])
            })
            
            let backAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(backAction)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            
        }
        joinMemberTabelView.reloadData()
    }
    
}
