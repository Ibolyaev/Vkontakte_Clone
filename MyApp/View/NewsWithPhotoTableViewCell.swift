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
            //viewedLabel?.text = "Viewed:\(news?.views?.count ?? 0)"
            likesLabel?.text = "Likes:\(news?.likes?.count ?? 0)"
            repostsLabel?.text = "Reposts:\(news?.reposts?.count ?? 0)"
            mainTextLabel?.text = news?.text
            print(news?.attachments?.first?.photo?.src_big)
            var text = news?.text ?? ""
            text = text.replacingOccurrences(of: "<br>", with: "")
            textView.text = text
        }
    }
    
    func confugurateCell(news:News) {
        self.news = news
    }
    @IBOutlet var textView: UITextView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var mainTextLabel: UILabel!
    @IBOutlet var mainNewsPicture: UIImageView!
    @IBOutlet var autorLabel: UILabel!
    @IBOutlet var repostsLabel: UILabel!
    @IBOutlet var viewedLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
}
