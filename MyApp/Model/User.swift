//
//  Friend.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//


import UIKit
import SwiftyJSON
import Realm

class User:RLMObject, Codable {
    
   var name: String {
        get {
            return firstName + " " + lastName
        }
    }
    @objc dynamic var lastName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var uid:String = ""
    var photo:Photo = Photo(url: "")
    
    convenience init(json:JSON) {
        self.init()
        lastName = json["last_name"].stringValue
        firstName = json["first_name"].stringValue
        uid = json["uid"].stringValue
        photo = Photo(url:json["photo_100"].stringValue)
    }
    
    public enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
    
}
