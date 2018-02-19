//
//  FriendTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    static let reuseIdentifier = "friendCell"
    var friend:User? {
        didSet {            
            nameLabel?.text = friend?.name
            if friend?.friendshipReuqest ?? false {
                self.backgroundColor = .lightGray
            } else {
                self.backgroundColor = .white
            }
            loadImage()
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView?.layer.cornerRadius = profileImageView.frame.width / 2
            profileImageView?.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    private func loadImage() {
        profileImageView?.image = nil
        if let urlString = friend?.photo?.url, let url = URL(string:urlString) {
            profileImageView?.sd_setImage(with: url, completed: nil)
        }
    }
    
}
