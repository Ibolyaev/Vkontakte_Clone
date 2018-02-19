//
//  ChatCell.swift
//  MyApp
//
//  Created by Ronin on 16/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation
import UIKit

protocol ChatCell {
    var timeStemp: UILabel! { get set }
    var messageTextView: UITextView! { get set }
}
