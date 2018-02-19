//
//  Message.swift
//  MyApp
//
//  Created by Ronin on 16/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation

struct MessageResponse: Codable {
    let items: [Message]
    let count: Int
}

struct Message: Codable {
    let id: Int
    let body: String
    let userID, fromID, date, readState: Int
    let out: Int
    let randomID, emoji: Int?
    lazy var fromattedDate: String = {
        let date = Date(timeIntervalSince1970: TimeInterval(self.date))
        let calendar = Calendar.current
        let dateFormat = DateFormatter()
        if calendar.isDate(date, inSameDayAs: Date()) {
            dateFormat.dateFormat = "HH:mm"
        } else {
           dateFormat.dateFormat = "MM-dd-yyyy"
        }
        return dateFormat.string(from: date)
    }()
    
    enum CodingKeys: String, CodingKey {
        case id, body
        case userID = "user_id"
        case fromID = "from_id"
        case date
        case readState = "read_state"
        case out
        case randomID = "random_id"
        case emoji
    }
}
