//
//  FriendCollectionViewCell.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "friendCollectionCell"
    var photo:AlbumPhoto? {
        didSet {
            loadImage()
        }
    }
    @IBOutlet weak var friendImageView: UIImageView!
    
    private func loadImage() {
        friendImageView?.image = nil
        if let url = photo?.URL {
            friendImageView?.sd_setImage(with: url, completed: nil)
        }
    }
}
