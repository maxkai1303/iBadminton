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
    
    func addEvent(collectionName: CollectionName, handler: @escaping() -> Void) {
        
        let doc = getCollection(name: .event).document()
        let noteText =
            """
            1、把簡單弄複雜是找事，把複雜弄簡單才是本事。
            2、所謂「成熟」就是，喜歡的東西依舊喜歡，但可以不擁有；討厭的東西依舊討厭，但可以忍受；害怕的東西依舊害怕，但可以面對。
            3、令人感到難過，不是因為你欺騙了我，而是因為我再也不能相信你了。
            4、敵人變成朋友，就比朋友更可靠，朋友變成敵人，比敵人更危險。有些事知道了就好，不必多說。有些人認識了就好，不必深交。
            5、能看穿你三方面的人值得信任：看穿你笑容背後的悲傷、諒解你怒火裡掩藏的善意、了解你沉默之下的原因。
            6、人生第一快樂是做到自己認為自己做不到的事，人生第二快樂是做到別人認為自己做不到的事。
            7、人越是怕丟人，就越是在乎別人的看法；越是在乎別人的看法，就越是會忽略自己的感受。"
            """
        
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
                          note: noteText)
        do {
            
            try doc.setData(from: event)
            
        } catch {
            
            print(error.localizedDescription)
        }
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
            "userImage": ""
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
    }
    
    func joinTeam(userId: String, teamID: String) {
        getCollection(name: .team).document(teamID).updateData([
            "teamMenber": FieldValue.arrayUnion([userId])
        ])
    }
    
    func edit(collectionName: CollectionName, handler: @escaping() -> Void) {
        getCollection(name: .event).document("57avlZeo1P1Ue1wMoBEE").updateData([
            "peopleRating": ["高山": 100]
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
