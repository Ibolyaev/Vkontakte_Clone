//
//  Photo.swift
//  MyApp
//
//  Created by Ronin on 31/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation
import UIKit
import Realm

class Photo:RLMObject {
    
    @objc dynamic var url:String = ""
    convenience init(url:String) {
        self.init()
        self.url = url
    }

}
