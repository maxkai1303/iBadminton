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
        getCollection(name: .event).document().setData([
            "dateStart": Timestamp(),
            "dateEnd": Timestamp(),
            "image": ["https://cf.shopee.tw/file/fb99ba8becd15becf1ab1513f5a40acc",
                      "https://srw.wingzero.tw/assets/robot/51b4a-6597188513911913476.jpg"],
            "joinID": ["高賽", "高子"],
            "price": 900,
            "teamID": "let辣條是shit",
            "status": true,
            "location": "AppWorksSchool",
            "ball": "200磅鉛球",
            "level": "中 - 高",
            "lackCount": 14
        ])
        
    }
    
    func joinEvent(id: String, event: String) {
        getCollection(name: .event).document(event).updateData([
            "joinID": FieldValue.arrayUnion([id])
        ])
    }
    
    func edit(collectionName: CollectionName, handler: @escaping() -> Void) {
        getCollection(name: .event).document("57avlZeo1P1Ue1wMoBEE").updateData([
            "peopleRating": ["高山": 100]
        ])
        print("======= Edit Sucess! =======")
    }
}
