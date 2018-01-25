//
//  StoryboardExtension.swift
//  MyApp
//
//  Created by Ronin on 25/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T>(controller: T.Type ) -> T? {
        return instantiateViewController(withIdentifier: String(describing: controller)) as? T
    }
}
