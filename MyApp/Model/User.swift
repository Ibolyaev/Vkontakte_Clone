//
//  Friend.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//


/*let decoded = try JSONDecoder().decode(MainJSON.self, from: data)

class MainJSON {
    var main:SolutionJSON?
}

class SolutionJSON {
    var exercises:[ExercisesJSON]?
}

class ExercisesJSON: Codable {
    var bookTitle: String?
    var releaseDate: String?
    var price: Double?
    ... etc
    
    enum CodingKeys: String, CodingKey {
        case bookTitle = "book_title"
        case releaseDate = "release_date"
        case price = "price"
    }
}*/

import UIKit
import SwiftyJSON
import RealmSwift

final class User:Object, Decodable {
    
   var name: String {
        get {
            return firstName + " " + lastName
        }
    }
    @objc dynamic var lastName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var uid:Int = 0
    @objc dynamic var photo:Photo?
    
    /*convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lastName = try values.decode(String.self, forKey: .lastName)
        firstName = try values.decode(String.self, forKey: .firstName)
        uid = try values.decode(Int.self, forKey: .uid)
        photo = try values.decode(Photo.self, forKey: .photo)
    }*/
    
    public enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case uid
        case photo = "photo_100"
    }
    
}
