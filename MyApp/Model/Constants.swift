//
//  Constants.swift
//  MyApp
//
//  Created by Ronin on 18/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation

struct Constants {
    struct SegueIdentifiers {
        static let mainScreen = "mainScreen"
    }
    //https://api.vk.com/method/users.get?user_id=210700286&v=5.52
    //https://api.vk.com/method/users.get?user_ids=210700286&fields=bdate
    struct VK {
        static let url = "https://api.vk.com"
        static let accessToken = "325f9bfb325f9bfb325f9bfb013200b9d33325f325f9bfb6bae006de8d253d3e2996849"
        static let urlUsers = "https://api.vk.com/method/users.get"
        static let urlFriends = "https://api.vk.com/method/friends.get"
        static let urlPhotosAll = "https://api.vk.com/method/photos.getAll"
        static let urlGroups = "https://api.vk.com/method/groups.get"
        static let urlGroupsSearch = "https://api.vk.com/method/groups.search"
    }
}
