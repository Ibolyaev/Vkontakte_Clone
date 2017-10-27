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
struct Friend {
    var name: String {
        get {
            return firstName + " " + lastName
        }
    }
    let lastName: String
    let firstName: String
    let uid:String
    let photoURL:String
    
    init(json:JSON) {
        lastName = json["last_name"].stringValue
        firstName = json["first_name"].stringValue
        uid = json["uid"].stringValue
        photoURL = json["photo_100"].stringValue
    }
    
    /*static func demoData() -> [Friend] {
        
        var friends = [Friend]()
    
        friends.append(Friend(name: "Bill Gates", profilePicture: UIImage(named:"Bill")))
        friends.append(Friend(name: "Steve Jobs", profilePicture: UIImage(named:"Steve")))
        friends.append(Friend(name: "Barak Obama", profilePicture: UIImage(named:"Barak")))
        friends.append(Friend(name: "Leonardo da Vinchi", profilePicture: UIImage(named:"Leo")))
        
        return friends
    }*/
    
}
