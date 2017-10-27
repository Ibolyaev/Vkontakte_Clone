//
//  GroupTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "groupCell"

    var group:Group? {
        didSet {
            nameLabel?.text = group?.name
            userCountLabel?.text = "\(group?.usersCount ?? 0) people"
            groupImageView?.image = group?.image
        }
    }
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!

}
