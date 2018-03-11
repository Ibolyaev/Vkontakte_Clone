//
//  LastNews.swift
//  MyApp
//
//  Created by Ronin on 27/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation
import RealmSwift

class LastNews: Object {       
    @objc dynamic var title = ""
    @objc dynamic var text = ""
    @objc dynamic var photoUrl = ""
    @objc dynamic var url = ""
    @objc dynamic var id: Int = 0
}
