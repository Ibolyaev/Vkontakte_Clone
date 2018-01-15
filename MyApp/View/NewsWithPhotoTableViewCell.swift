//
//  NewsWithPhotoTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 08/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

class NewsWithPhotoTableViewCell: UITableViewCell, NewsCell {

    static let reuseIdentifier = "newsWithPhoto"
    var news:News? {
        didSet {
            //commentsButton?.setTitle("\(news?.comments.count ?? 0)", for: UIControlState.normal)
            viewedLabel?.text = "\(news?.views?.count ?? 0)"
            likesLabel?.text = "\(news?.likes?.count ?? 0)"
            repostsLabel?.text = "\(news?.reposts?.count ?? 0)"
            profileName?.text = news?.text
            //profileImageView?.image = UIImage(named: "comments")
        }
    }
    
    func confugurateCell(news:News) {
        self.news = news
    }
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var mainTextLabel: UILabel!
    @IBOutlet var mainNewsPicture: UIImageView!
    @IBOutlet var autorLabel: UILabel!
    @IBOutlet var repostsLabel: UILabel!
    @IBOutlet var viewedLabel: UILabel!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var likesLabel: UILabel!
    
}
