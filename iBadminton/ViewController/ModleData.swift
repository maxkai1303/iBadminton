//
//  ModleData.swift
//  iBadminton
//
//  Created by Max Kai on 2020/12/3.
//

import Foundation

struct Event: Codable {
    var joinID: [String]
    var location: String
    var dateStart: Date
    var dateEnd: Date
    var price: Int
    var teamID: String
    var status: Bool
    var peopleRating: [String: Int]
    var teamRating: [String: Int]
    var image: [String]
}
