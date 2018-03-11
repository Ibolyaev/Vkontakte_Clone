//
//  Profile.swift
//  MyApp
//
//  Created by Ronin on 30/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var title: String
    var profilePhotoURL: String?
    
    init(_ group: Group) {
        title = group.title
        profilePhotoURL = group.profilePhotoURL
    }
    
    init(_ profile: Profiles) {
        title = profile.title
        profilePhotoURL = profile.profilePhotoURL
    }
}
