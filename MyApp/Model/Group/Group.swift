//
//  Group.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import RealmSwift

final class Group: Object, Decodable {
    
    var title: String { return screenName }
    var profilePhotoURL: String? { return photo?.url }
    
    @objc dynamic var name:String = ""
    @objc dynamic var screenName:String = ""
    @objc dynamic var id:Int = 0
    @objc dynamic var usersCount = 0
    @objc dynamic var currentUserInGroup = false
    @objc dynamic var photo:Photo?
    var numberOfGroups: Int = 0
    
    public enum CodingKeys: String, CodingKey {
        case name
        case id
        case screenName = "screen_name"
        case photo = "photo_100"
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
