//
//  Friend.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
struct Friend {
    let name: String
    let profilePicture:UIImage?
    
    static func demoData() -> [Friend] {
        
        var friends = [Friend]()
    
        friends.append(Friend(name: "Bill Gates", profilePicture: UIImage(named:"Bill")))
        friends.append(Friend(name: "Steve Jobs", profilePicture: UIImage(named:"Steve")))
        friends.append(Friend(name: "Barak Obama", profilePicture: UIImage(named:"Barak")))
        friends.append(Friend(name: "Leonardo da Vinchi", profilePicture: UIImage(named:"Leo")))
        
        return friends
    }
    
}
