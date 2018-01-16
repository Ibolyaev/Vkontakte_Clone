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
    var news:News? {
        didSet {
            //commentsButton?.setTitle("\(news?.comments.count ?? 0)", for: UIControlState.normal)
            //viewedLabel?.text = "Viewed:\(news?.views?.count ?? 0)"
            //likesLabel?.text = "Likes:\(news?.likes?.count ?? 0)"
            //repostsLabel?.text = "Reposts:\(news?.reposts?.count ?? 0)"
            //print(news?.attachments?.first?.photo?.src_big)
            var text = news?.text ?? ""
            text = text.replacingOccurrences(of: "<br>", with: "")
            textView.text = text
            mainNewsPicture?.image = nil
            print(text)
            // switch on type
            // TO-DO Change type to enum
            guard let news = news else {
                return                
            }
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
    }
    
    var group:NewsGroups? {
        didSet {
            profileName.text = group?.name
            loadImage(group?.photo_medium ?? "", imageView: profileImageView)
        }
    }
    var profile:Profiles? {
        didSet {
            profileName.text = profile?.screen_name
            loadImage(profile?.photo_medium_rec ?? "", imageView: profileImageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       /*mainNewsPicture.frame = CGRectMake(5,5,40,32.5);
        float limgW =  self.imageView.image.size.width;
        if(limgW > 0) {
            self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
            self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
        }*/
        self.needsUpdateConstraints()
    }
    
    func loadImage(_ url:String, imageView:UIImageView) {
        DispatchQueue.global(qos: .userInitiated).async {
            Alamofire.request(url).responseData {[weak self] (response) in
                if response.result.isSuccess,
                    let data = response.result.value,
                    let image = UIImage(data: data) {
                    if url == response.request?.url?.absoluteString {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    func confugurateCell(news:News) {
        self.news = news
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
