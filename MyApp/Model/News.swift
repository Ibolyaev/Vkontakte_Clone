//
//  News.swift
//  MyApp
//
//  Created by Ronin on 08/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation
import RealmSwift

final class News:Object, Decodable {
    
    @objc dynamic var type: String = ""
    @objc dynamic var sourceId:Int = 0
    var likes:[String] = [String]()
    var comments:[String] = [String]()
    var reposts:[String] = [String]()
    var viewed:Int = 0
    var text:String = ""
    
    override static func primaryKey() -> String? {
        return "sourceId"
    }
    
    public enum CodingKeys: String, CodingKey {
        case type
        case sourceId = "source_id"
    }
}
