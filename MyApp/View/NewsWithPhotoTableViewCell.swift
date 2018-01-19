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
    var news:News?
    var group:Group? {
        didSet {
            profileName.text = group?.name
            if let urlString = group?.photo?.url, let url = URL(string:urlString) {
               loadImage(url, imageView: profileImageView)
            }  
        }
    }
    var profile:Profiles? {
        didSet {
            profileName.text = profile?.screen_name
            if let urlString = profile?.photo_100, let url = URL(string:urlString) {
                loadImage(url, imageView: profileImageView)
            }
        }
    }
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var mainNewsPicture: UIImageView!
    @IBOutlet var autorLabel: UILabel!
    @IBOutlet var repostsLabel: UILabel!
    @IBOutlet var viewedLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
    func loadImage(_ url:URL, imageView:UIImageView) {
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
        } else {
            print("No picture")
        }
    }
    
    func confugurateCell(news:News) {
        self.news = news
        loadTextFrom(news)
        loadFooterFrom(news)
        loadImagesFrom(news)
    }
    
    
}
