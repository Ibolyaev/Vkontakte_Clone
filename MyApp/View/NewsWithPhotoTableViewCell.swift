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
    var group:NewsGroups? {
        didSet {
            profileName.text = group?.name
            if let urlString = group?.photo_medium, let url = URL(string:urlString) {
               loadImage(url, imageView: profileImageView)
            }  
        }
    }
    var profile:Profiles? {
        didSet {
            profileName.text = profile?.screen_name
            if let urlString = profile?.photo_medium_rec, let url = URL(string:urlString) {
                loadImage(url, imageView: profileImageView)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.needsUpdateConstraints()
    }
    
    func loadImage(_ url:URL, imageView:UIImageView) {
        imageView.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
    }
    
    func confugurateCell(news:News) {
        self.news = news
        var text = news.text ?? ""
        text = text.replacingOccurrences(of: "<br>", with: "")
        textView.text = text
        mainNewsPicture?.image = nil
        
        var urlString:String?
        switch news.type {
        case "wall_photo"?:
            urlString = news.photos?.first(where: { (photo) -> Bool in
                return photo.numberOfPhotos == nil
            })?.src_big
        default:
            urlString = news.attachments?.first?.photo?.src_big
        }
        
        if let url = URL(string:urlString ?? "")  {
            mainNewsPicture?.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.highPriority, completed: nil)
        } else {
            print("No picture")
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
    
}
