//
//  Group.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import RealmSwift

final class Group:Object, Decodable, Profilable {
    
    var title: String { return screenName }
    var profilePhotoURL: String? { return photo?.url }
    
    @objc dynamic var name:String = ""
    @objc dynamic var screenName:String = ""
    @objc dynamic var id:Int = 0
    @objc dynamic var usersCount = 0
    @objc dynamic var currentUserInGroup = false
    @objc dynamic var photo:Photo?
    var numberOfGroups:Int = 0
    
    public enum CodingKeys: String, CodingKey {
        case name
        case id
        case screenName = "screen_name"
        case photo = "photo_100"
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(from decoder: Decoder) throws {
        self.init()
        // ВКонтакте передает массив групп в ответе, но первый элемент массива, это количество групп,
        // пытаемся распарсить группу, если не получилось, значит это первый элемент с количеством групп
        if let values = try? decoder.container(keyedBy: CodingKeys.self) {
            name = try values.decode(String.self, forKey: .name)
            id = try values.decode(Int.self, forKey: .id)
            screenName = try values.decode(String.self, forKey: .screenName)
            photo = try values.decode(Photo.self, forKey: .photo)
        } else {
            numberOfGroups = try decoder.singleValueContainer().decode(Int.self)
        }
    }
}
