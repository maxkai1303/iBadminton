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
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum FirebaseError: String, Error {
    case decode = "====== FireBase decode error ======"
}

class FireBaseManager {
    
    private let fireDb = Firestore.firestore()
    
    static let shared = FireBaseManager()
    
    private init() { }
    
    var currentTimestamp: Timestamp {
        return Firebase.Timestamp()
    }
    
    func getCollection(name: CollectionName) -> CollectionReference {
        switch name {
        case .event: return Firestore.firestore().collection(name.rawValue)
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
    
    func add(collectionName: CollectionName, handler: @escaping() -> Void) {
        getCollection(name: .event).document().setData([
            "DateStart": "2020/12/30 12:00",
            "DateEnd": "",
            "Image": ["ccccc", "iiiii"],
            "JoinID": ["高集", "高檔"],
            "Price": 150,
            "TeamID": "let辣條=shit",
            "Status": true,
            "PeopleRating": ["高集": 3, "高檔": 5],
            "TeamRating": ["高集": 2, "高檔": 1],
            "Location": "你家樓下"
        ], merge: true)
        
    }
    
    func edit(collectionName: CollectionName, handler: @escaping() -> Void) {
        getCollection(name: .event).document("57avlZeo1P1Ue1wMoBEE").updateData([
            "PeopleRating": ["高山": 100]
        ])
        print("======= Edit Sucess! =======")
    }
}
