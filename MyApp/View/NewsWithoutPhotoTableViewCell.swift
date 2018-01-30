//
//  NewsWithPhotoTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 08/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class NewsWithoutPhotoTableViewCell: UITableViewCell, NewsCell {

    static let reuseIdentifier = "newsWithoutPhoto"
    var news: News? {
        didSet {
            profile = news?.profile
        }
    }
    var profile: Profile?
    
    func loadImage(_ url: URL, imageView: UIImageView) {
        imageView.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
    }
    
    func confugurateCell(news: News) {
        self.news = news
        loadProfile()
        loadTextFrom(news)
        loadFooterFrom(news)
    }
    @IBOutlet var textView: UITextView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var autorLabel: UILabel!
    @IBOutlet var repostsLabel: UILabel!
    @IBOutlet var viewedLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
}
