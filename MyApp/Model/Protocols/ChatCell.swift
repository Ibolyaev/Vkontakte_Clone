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
    var messageTextView: UILabel! {get set}
    var timeStemp: UILabel! {get set}
    var bubbleImageView: UIImageView! {get set}
}

extension ChatCell {
    func changeImage(_ name: String) {
        guard let image = UIImage(named: name) else { return }
        bubbleImageView.image = image
            .withRenderingMode(.alwaysTemplate)
        /*bubbleImageView.image = image
         .resizableImage(withCapInsets:
         UIEdgeInsetsMake(17, 21, 17, 21),
         resizingMode: .stretch)
         .withRenderingMode(.alwaysTemplate)*/
    }
}
