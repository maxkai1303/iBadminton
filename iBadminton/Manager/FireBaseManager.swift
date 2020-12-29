//
//  FireBaseManager.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/2.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import PKHUD
import FirebaseAuth

typealias FIRTimestamp = Timestamp

enum CollectionName: String {
    case event = "Event"
    case user = "User"
    case team = "Team"
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum UploadFile: String {
    case event = "eventImage"
    case team = "teamImage"
}

enum FirebaseError: String, Error {
    case decode = "====== FireBase decode error ======"
}

class FireBaseManager {
    
    let fireDb = Firestore.firestore()
    
    static let shared = FireBaseManager()
    
    private init() { }
    
    var currentTimestamp: Timestamp {
        return Firebase.Timestamp()
    }
    
    func getCollection(name: CollectionName) -> CollectionReference {
        switch name {
        case .event: return Firestore.firestore().collection(name.rawValue)
        case .user: return Firestore.firestore().collection(name.rawValue)
        case .team: return Firestore.firestore().collection(name.rawValue)
        }
    }
    
    func read <T: Codable> (collectionName: CollectionName, dataType: T.Type, handler: @escaping (Result<[T]>) -> Void) {
        let collection = getCollection(name: collectionName)
        collection.getDocuments(completion: { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                handler(.failure(error!))
                return
            }
            self.decode(dataType, documents: querySnapshot.documents) { (result) in
                switch result {
                case .success(let data): handler(.success(data))
                case .failure(let error): handler(.failure(error))
                }
            }
        })
    }
    
    func decode<T: Codable>(_ dataType: T.Type, documents: [QueryDocumentSnapshot], handler: @escaping (Result<[T]>) -> Void) {
        var datas: [T] = []
        for document in documents {
            guard let data = try? document.data(as: dataType) else {
                handler(.failure(FirebaseError.decode))
                return
            }
            datas.append(data)
        }
        handler(.success(datas))
    }
    
    func decode<T: Codable>(_ dataType: T.Type, document: DocumentSnapshot, handler: @escaping (Result<T>) -> Void) {
        
        var data: T
        
        guard let result = try? document.data(as: dataType) else {
            handler(.failure(FirebaseError.decode))
            return
        }
        
        data = result
        
        handler(.success(data))
    }
    
    func listen(collectionName: CollectionName, handler: @escaping() -> Void) {
        let collection = getCollection(name: collectionName)
        collection.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document:", error!)
                return
            }
            
            if document.documents.isEmpty {
                return
            } else {
                let data = document.documents[0].data()
                print("監聽到的資料: \(data)")
                handler()
            }
        }
    }
    
    func addEvent(doc: DocumentReference, event: Event, handler: @escaping() -> Void) {
        do {
            
            try doc.setData(from: event)
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    func getOwnTeam(userId: String, handler: @escaping ([Team]) -> Void) {
        let collection = FireBaseManager.shared.getCollection(name: .team)
        collection.whereField("adminID", arrayContains: userId).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.decode(Team.self, documents: querySnapshot!.documents) { (result) in
                    switch result {
                    case .success(let item):
                        handler(item)
                    case .failure(let error):
                        print("Get own team decode error: \(error)")
                    }
                }
            }
        }
    }
    
    func addTimeline(teamDoc: String, content: String, event: Bool) {
        let doc = getCollection(name: .team).document(teamDoc).collection("TeamPoint")
        doc.document().setData([
            "content": content,
            "event": event,
            "time": Timestamp()
        ], merge: true) { error in
            
            if let error = error {
                print(error)
            } else {
                print("success")
            }
        }
    }
    
    // MARK: 首次登入創建 User
    func addUser(collectionName: CollectionName, userId: String) {
        getCollection(name: .user).document(userId).setData([
            "userID": userId,
            "userName": userId,
            "joinCount": 0,
            "noShow": 0,
            "rating": [],
            "message": ["歡迎加入 iBadminton, 建議修改暱稱讓大家認得你喔！"],
            "userImage": "https://image-cdn-flare.qdm.cloud/q695f49b90fa4a/image/cache/data/2020/03/23/1b74981886c474fe8ade85d442295c35-max-w-1024.jpg"
        ])
    }
    
    func checkLogin(handler: @escaping (String?) -> Void) {
        Auth.auth().addStateDidChangeListener { (_, user) in
            if let user = user {
                print("\(String(describing: user.uid))")
                print("\(String(describing: user.email)) login")
                handler(user.uid)
            } else {
                print("not login")
                handler(nil)
            }
        }
    }
    
    func joinEvent(userId: String, event: String) {
        
        let doc = getCollection(name: .event).document(event)
       
        doc.getDocument { (document, _) in
            if let document = document, document.exists {
                let lack = document.data()!["lackCount"] as? Int ?? 0
                let member = document.data()!["joinID"] as? Array<String> ?? []
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                switch lack - member.count {
                case 0:
                    doc.updateData([
                        "status": false
                    ])
                    HUD.flash(.labeledError(title: "Oops！", subtitle: "這個活動已經滿員了！"), delay: 1.3)
                    
                case 1:
                    doc.updateData([
                        "joinID": FieldValue.arrayUnion([userId]),
                        "status": false
                    ])
                    HUD.flash(.labeledSuccess(title: "Success！", subtitle: "加入成功記得去打球喔！"), delay: 1.3)
                    
                default:
                    doc.updateData([
                        "joinID": FieldValue.arrayUnion([userId])
                    ])
                    HUD.flash(.labeledSuccess(title: "Success！", subtitle: "加入成功記得去打球喔！"), delay: 1.3)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func joinTeam(userId: String, teamID: String) {
        
        getCollection(name: .user).document(userId).getDocument { (document, _) in
            if let document = document, document.exists {
                self.getCollection(name: .team).document(teamID).updateData([
                    "teamMenber": FieldValue.arrayUnion([userId])
                ])
                print(document.documentID, document.data()!)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getUserName(userId: String, handler: @escaping (String?) -> Void) {
        getCollection(name: .user).document(userId).getDocument { (document, _) in
            if let document = document, document.exists {
                let name = "\(document.data()!["userName"] ?? "沒有名字")"
                print(document.documentID, document.data()!)
                handler(name)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func addNewTeam(
        admin: [String],
        image: String,
        menber: [String],
        message: String,
        teamName: String,
        handler: @escaping (String) -> Void) {
        let doc = getCollection(name: .team).document()
        doc.setData([
            "teamImage": image,
            "teamMessage": message,
            "teamMenber": menber,
            "adminID": admin,
            "teamRating": [],
            "teamID": doc.documentID,
            "teamName": teamName,
            "createTime": Timestamp()
        ]) { error in
            
            if let error = error {
                print(error)
            } else {
                handler(doc.documentID)
            }
            
        }
    }
    
    func checkJoinEvent(userId: String, eventId: String) {
        let doc = getCollection(name: .event).document(eventId)
        doc.getDocument { (document, _) in
            if let document = document {
                guard let join = document["joinID"] as? [String] else { return }
                
                if join.contains(userId) {
                    HUD.flash(.labeledError(title: "哎呀！", subtitle: "你加入過這個活動囉！"), delay: 1.3)
                    
                } else {
                    self.joinEvent(userId: userId, event: eventId)
                }
            }
        }
    }
    
    func checkJoinTeam(userId: String, teamId: String, name: String) {
        let doc = getCollection(name: .team).document(teamId)
        doc.getDocument { (document, _) in
            if let document = document {
                guard let join = document["teamMenber"] as? [String] else { return }
                
                if join.contains(userId) {
                    HUD.flash(.labeledError(title: "哎呀！", subtitle: "你加入過這個球隊囉！"), delay: 1.3)
                    
                } else {
                    self.joinTeam(userId: userId, teamID: teamId)
                    self.addTimeline(teamDoc: teamId, content: "\(name) 加入球隊", event: false)
                    HUD.flash(.labeledSuccess(title: "Success！", subtitle: "加入球隊成功！"), delay: 1.3)
                }
            }
        }
    }
    
    func editName(collectionName: CollectionName, userId: String, key: String, value: Any, handler: @escaping() -> Void) {
        getCollection(name: collectionName).document(userId).updateData([
            key: value
        ])
        print("======= Edit Sucess! =======")
    }
    
    func timeStampToStringDetail(_ timeStamp: Timestamp) -> String {
        let timeSta = timeStamp.dateValue()
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dfmatter.string(from: timeSta)
    }
    
    func dataToTimeStamp(_ stringTime: Date) -> Timestamp {
        
        return Timestamp(date: stringTime)
    }
}
