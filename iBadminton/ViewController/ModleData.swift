//
//  ModleData.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/3.
//

import Foundation
import Firebase

struct Event: Codable {
    var joinID: [String]
    var location: String
    var dateStart: Timestamp
    var dateEnd: Timestamp
    var price: Int
    var teamID: String
    var status: Bool
    var peopleRating: [String: Int]
    var teamRating: [String: Int]
    var image: [String]
    var ball: String
    var level: String
}

struct Uesr: Codable {
    var userID: String
    var userName: String
    var userImage: String
    var message: String
    var join: Int
    var noShow: Int
}

struct Team: Codable {
    var teamID: String
    var teamName: String
    var teamImage: [String]
    var teamMessage: String
    var teamMenber: [String]
    var adminID: [String]
}
