//
//  Group.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

final class Group:Object, Decodable {
        
    @objc dynamic var name:String = ""
    @objc dynamic var screenName:String = ""
    @objc dynamic var gid:String = ""
    @objc dynamic var usersCount = 0
    @objc dynamic var currentUserInGroup = false
    @objc dynamic var photo:Photo?
    
    public enum CodingKeys: String, CodingKey {
        case name
        case gid
        case screenName
        case photo = "photo_medium"
    }
    convenience init(from decoder: Decoder) throws {
     self.init()
     let values = try decoder.container(keyedBy: CodingKeys.self)
     name = try values.decode(String.self, forKey: .name)
     gid = try values.decode(String.self, forKey: .gid)
     screenName = try values.decode(String.self, forKey: .screenName)
     photo = try values.decode(Photo.self, forKey: .photo)
     }
    /*convenience init(json:JSON) {
        self.init()
        name = json["name"].stringValue
        screenName = json["screenName"].stringValue
        gid = json["gid"].stringValue
        usersCount = 0
        //photo = Photo(url:json["photo_medium"].stringValue)
        currentUserInGroup = true
    }*/
}
