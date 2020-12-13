//
//  ModleData.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/3.
//

import Foundation
import Firebase

struct Event: Codable {
    var ball: String
    var dateStart: Timestamp
    var dateEnd: Timestamp
    var eventID: String
    var image: [String]
    var joinID: [String]
    var lackCount: Int
    var level: String
    var location: String
    var price: Int
    var status: Bool
    var teamID: String
    var tag: [String]
    var note: String
}

struct User: Codable {
    var userID: String
    var userName: String
    var userImage: String
    var message: [String]
    var joinCount: Int
    var noShow: Int
    var rating: [Int]
}

struct Team: Codable {
    var teamImage: [String]
    var teamMessage: String
    var teamMenber: [String]
    var adminID: String
    var teamRating: [Int]
    var teamID: String
}

struct TeamPoint: Codable {
    var event: Bool
    var time: Timestamp
    var content: String
}
