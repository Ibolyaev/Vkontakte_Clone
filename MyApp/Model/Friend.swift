//
//  Friend.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

/*"last_name" : "Inozemtsev",
"first_name" : "Igor",
"uid" : 137173972*/

import UIKit
import SwiftyJSON

class Friend {
    
    var name: String {
        get {
            return firstName + " " + lastName
        }
    }
    let lastName: String
    let firstName: String
    let uid:String
    let photo:Photo
    
    init(json:JSON) {
        lastName = json["last_name"].stringValue
        firstName = json["first_name"].stringValue
        uid = json["uid"].stringValue
        photo = Photo(url:json["photo_100"].stringValue)
    }
    
}
