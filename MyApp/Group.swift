//
//  Group.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

struct Group:Equatable {
    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
        
    let name:String
    let usersCount:Int
    let image:UIImage?
    var currentUserInGroup:Bool
    
    static func demoData() -> [Group] {
        
        var userGroups = [Group]()
        
        userGroups.append(Group(name: "Microsoft guys", usersCount: 1000, image: UIImage(named:"Microsoft"), currentUserInGroup: false))
        userGroups.append(Group(name: "Apple guys", usersCount: 2000, image: UIImage(named:"Apple"), currentUserInGroup: true))
        userGroups.append(Group(name: "Fishing lovers", usersCount: 2000, image: UIImage(named:"Fishing"), currentUserInGroup: false))
        userGroups.append(Group(name: "1C", usersCount: 2000, image: UIImage(named:"One"), currentUserInGroup: true))
        
        return userGroups
    }
}
