//
//  NewsTextOnlyTableViewCell.swift
//  MyApp
//
//  Created by Ronin on 08/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

class NewsPhotoUpdateTableViewCell: UITableViewCell, NewsCell {
    
    static let reuseIdentifier = "newsPhotoUpdate"
    var news:News? {
        didSet {
            commentsButton?.setTitle("\(news?.comments.count ?? 0)", for: UIControlState.normal)
            //viewedLabel?.text = "\(news?.viewed ?? 0)"
            //likesLabel?.text = "\(news?.likes.count ?? 0)"
            //repostsLabel?.text = "\(news?.reposts.count ?? 0)"
        }
    }
    @IBOutlet var commentsButton: UIButton!
    
    func confugurateCell(news:News) {
        self.news = news
    }
    
}
