//
//  LastNewsWatch.swift
//  Watch Extension
//
//  Created by Ronin on 02/03/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation

class LastNewsWatch: NSObject, NSCoding {
    
    var title: String = ""
    var text: String = ""
    var photoUrl: String = ""
    
    init(_ title: String, text: String, photoUrl: String) {
        self.title = title
        self.text = text
        self.photoUrl = photoUrl
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObject(forKey: "title") as? String,
            let text = decoder.decodeObject(forKey: "text") as? String,
            let photoUrl = decoder.decodeObject(forKey: "photoUrl") as? String
            else { return nil }
        
        self.init(
            title,
            text: text,
            photoUrl: photoUrl
        )
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.text, forKey: "text")
        coder.encode(self.photoUrl, forKey: "photoUrl")
    }
}
