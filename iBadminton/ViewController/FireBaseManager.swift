//
//  FireBaseManager.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/2.
//

import Foundation
import Firebase

class FireBaseManager {
    
    private let fireDb = Firestore.firestore()
    
    func readEvet() {
        fireDb.collection("Event").getDocuments {  (document, _) in
            if let document = document {
                _ = document.documents.map {
                    print($0.data())
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func listen() {
        fireDb.collection("Event").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let data = document.documents[0].data()
            print("監聽到的資料: \(data)")
        }
    }
    
    func addEvent() {
        fireDb.collection("Event").document().setData([
            "DateStart": "",
            "DateEnd": "",
            "ID": "高集",
            "Price": 150,
            "TeamID": "let辣條=shit",
            "Status": true,
            "PeopleRating": 3,
            "TeamRating": 5,
            "Location": "你家樓下"
        ])
    }
}
