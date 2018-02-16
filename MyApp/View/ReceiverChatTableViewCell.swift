//
//  ChatTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 16/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

class ReceiverChatTableViewCell: UITableViewCell, ChatCell {
    
    @IBOutlet var messageTextView: UILabel! {
        didSet {
           messageTextView?.textColor = UIColor(named: "chat_text_color_sent")
        }       
    }
    @IBOutlet var timeStemp: UILabel!
    static let reuseIdentifier = "ReceiverChatTableViewCell"
    @IBOutlet var bubbleImageView: UIImageView! {
        didSet {
            changeImage("chat_bubble_sent")
            bubbleImageView.tintColor = UIColor(named: "chat_bubble_color_sent")
        }
    }
    
    func sentButtonTapped(_ sender: UIButton) {
        changeImage("chat_bubble_sent")
        bubbleImageView.tintColor = UIColor(named: "chat_bubble_color_sent")
    }
    
    func receivedButtonTapped(_ sender: UIButton) {
        changeImage("chat_bubble_received")
        bubbleImageView.tintColor = UIColor(named: "chat_bubble_color_received")
    }
    
}
