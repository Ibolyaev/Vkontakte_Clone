//
//  UserGroupTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

class UserGroupTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "userGroupCell"
    
    var group:Group? {
        didSet {
            nameLabel?.text = group?.name
            loadImage()
        }
    }
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private func loadImage() {
        groupImageView?.image = nil
        if let urlString = group?.photo?.url, let url = URL(string:urlString) {
            groupImageView?.sd_setImage(with: url, completed: nil)
        }
    }
}
