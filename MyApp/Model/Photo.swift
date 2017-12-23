//
//  Photo.swift
//  MyApp
//
//  Created by Ronin on 31/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import RealmSwift

final class Photo:Object, Decodable {
    
    @objc dynamic var url:String = ""
    convenience init(from decoder: Decoder) throws {
        self.init()
        url = try decoder.singleValueContainer().decode(String.self)
    }
    override static func primaryKey() -> String? {
        return "url"
    }
}
