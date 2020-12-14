//
//  FireBaseManager.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/2.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum CollectionName: String {
    case event = "Event"
    case user = "User"
    case team = "Team"
}

enum Result<T> {
    case success(T)
    case failure(Error)
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
    
    func listen(collectionName: CollectionName, handler: @escaping() -> Void) {
        let collection = getCollection(name: .event)
        collection.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document:", error!)
                return
            }
            let data = document.documents[0].data()
            print("監聽到的資料: \(data)")
            handler()
        }
    }
    
    // MARK: 要拿到球隊的資訊，直接帶入新活動
    func addEvent(collectionName: CollectionName, handler: @escaping() -> Void) {
        let doc = getCollection(name: collectionName).document()
        var noteText: String = ""
//                getCollection(name: .team).getDocuments { (querySnapshot, _) in
//                    if let querySnapshot = querySnapshot {
//                       for document in querySnapshot.documents {
//                        noteText = document.data()["teamMessage"] as! String
//                          print(document.data())
//                       }
//                    }
//                 }
        
        let event = Event(ball: "200磅鉛球",
                          dateStart: Timestamp(),
                          dateEnd: Timestamp(),
                          eventID: doc.documentID,
                          image: ["jjiji"],
                          joinID: [],
                          lackCount: 14,
                          level: "中 - 高",
                          location: "AppWorksSchool",
                          price: 4,
                          status: true,
                          teamID: "let辣條=shit",
                          tag: ["停車場", "辣妹陪打", "霓虹燈"],
                          note: noteText
        )
        do {
            
            try doc.setData(from: event)
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    // MARK: 這個 func 會直接跳出去
    func getOwnTeam(userName: String) {
        let collection = FireBaseManager.shared.getCollection(name: .team)
        collection.whereField("adminID", isEqualTo: userName).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("Get Own Team:\(document.data())")
                }
            }
        }
    }
    
    func addTimeline(team: String, content: String, event: Bool) {
        let doc = getCollection(name: .team).document(team).collection("TeamPoint")
        doc.document().setData([
            "content": content,
            "event": event,
            "time": Timestamp()
        ])
    }
    
    // MARK: 首次登入創建 User
    func addUser(collectionName: CollectionName, userId: String) {
        getCollection(name: .user).document("\(userId)").setData([
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
    
    func joinEvent(userId: String, event: String, lackCout: Int) {
        getCollection(name: .event).document(event).updateData([
            "joinID": FieldValue.arrayUnion([userId]),
            "lackCount": lackCout - 1
        ])
        if lackCout == 0 {
            getCollection(name: .event).document(event).updateData([
                "status": false
            ])
        }
    }
    
    func joinTeam(userId: String, teamID: String) {
//        var name = ""
        getCollection(name: .user).document(userId).getDocument { (document, _) in
            if let document = document, document.exists {
//                name = "\(document.data()!["userName"] ?? "靠杯")"
                self.getCollection(name: .team).document(teamID).updateData([
                    "teamMenber": FieldValue.arrayUnion([userId])
                ])
                print(document.documentID, document.data()!)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getUserName(userId: String) -> String {
        var name = ""
        getCollection(name: .user).document(userId).getDocument { (document, _) in
            if let document = document, document.exists {
                name = "\(document.data()!["userName"] ?? "沒有名字")"
                print(document.documentID, document.data()!)
            } else {
                print("Document does not exist")
            }
        }
        return name
    }
    
    func addNewTeam(admin: String, teamId: String, image: [String], menber: [String], message: String) {
        getCollection(name: .team).document(teamId).setData([
            "teamImage": ["https://onepage.nownews.com/sites/default/files/styles/crop_thematic_content_img/public/2020-05/04_6.jpg?h=bd907a81&itok=rxDfBMr8"],
            "teamMessage": message,
            "teamMenber": menber,
            "adminID": admin,
            "teamRating": [],
            "teamID": teamId
        ])
    }
        
        func edit(collectionName: CollectionName, userId: String, key: String, value: Any, handler: @escaping() -> Void) {
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
    }
