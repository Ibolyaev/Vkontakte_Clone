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

class NewsWithPhotoTableViewCell: UITableViewCell, NewsCell {

    static let reuseIdentifier = "newsWithPhoto"
    var news: News?
    var profile: Profilable?
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var mainNewsPicture: UIImageView!
    @IBOutlet var autorLabel: UILabel!
    @IBOutlet var repostsLabel: UILabel!
    @IBOutlet var viewedLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
    func loadImage(_ url: URL, imageView: UIImageView) {
        imageView.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
    }
    
    private func loadImagesFrom(_ news:News) {
        mainNewsPicture?.image = nil
        var urlString:String?
        if let attachment = news.attachments?.first {
            switch attachment.type {
            case "photo" : urlString = attachment.photo?.photo_604
            case "video" : urlString = attachment.video?.image
            default :
                break
            }
        }
        if let url = URL(string:urlString ?? "")  {
            mainNewsPicture?.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
        }
    }
    
    func confugurateCell(news: News) {
        self.news = news
        loadTextFrom(news)
        loadProfile()
        loadFooterFrom(news)
        loadImagesFrom(news)
    }
    
}
