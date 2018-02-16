//
//  ChatTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 16/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

class SenderChatTableViewCell: UITableViewCell {
    @IBOutlet var messageTextView: UILabel!
    @IBOutlet var timeStemp: UILabel!
    static let reuseIdentifier = "ChatTableViewCell"
    @IBOutlet var bubbleImageView: UIImageView!
    
    func sentButtonTapped(_ sender: UIButton) {
        changeImage("chat_bubble_sent")
        bubbleImageView.tintColor = UIColor(named: "chat_bubble_color_sent")
    }
    
    func receivedButtonTapped(_ sender: UIButton) {
        changeImage("chat_bubble_received")
        bubbleImageView.tintColor = UIColor(named: "chat_bubble_color_received")
    }
    
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
