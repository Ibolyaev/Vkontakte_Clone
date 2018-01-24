//
//  GroupTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import SDWebImage

class GroupTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "groupCell"

    var group:Group? {
        didSet {
            nameLabel?.text = group?.name
            userCountLabel?.text = "\(group?.usersCount.formatUsingAbbrevation() ?? "0") people"
            loadMembersCount()
            loadImage()
        }
    }
    let clientVK = VKontakteAPI()
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!
    
    private func loadImage() {
        groupImageView?.image = nil
        if let urlString = group?.photo?.url, let url = URL(string:urlString) {
            groupImageView?.sd_setImage(with: url, completed: nil)
        }
    }
    
    private func loadMembersCount() {
        guard let group = group else { return }
        
        clientVK.getGroupMembers(groupId: group.id, completionHandler: {[weak self] (membersCount, groupId, error) in
            if group.id == groupId {
                DispatchQueue.main.async {
                    self?.userCountLabel?.text = "\(membersCount.formatUsingAbbrevation())"
                }
            }
        })
    }

}
