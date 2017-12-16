//
//  AlbumPhoto.swift
//  MyApp
//
//  Created by Игорь Боляев on 16.12.17.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
struct AlbumPhoto:Decodable {
    
    let pid:Int
    let ownerId:Int
    let URL:URL
    
    public enum CodingKeys: String, CodingKey {
        case pid
        case ownerId = "owner_id"
        case URL = "src"
    }
}
