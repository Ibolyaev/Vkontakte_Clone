//
//  Friend.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//
import Foundation
import RealmSwift

final class User:Object, Decodable {
    
   var name: String {
        get {
            return firstName + " " + lastName
        }
    }
    @objc dynamic var lastName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var id:Int = 0
    @objc dynamic var photo:Photo?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case id = "id"
        case photo = "photo_100"
    }    
}




