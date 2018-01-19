//
//  NewsCell.swift
//  MyApp
//
//  Created by Ronin on 08/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

protocol NewsCell  {
    func confugurateCell(news:News)
    var group:Group? { get set }
    var profile:Profiles? { get set }
    var repostsLabel: UILabel! { get set }
    var viewedLabel: UILabel! { get set }
    var commentsLabel: UILabel! { get set }
    var likesLabel: UILabel! { get set }
    var textView: UITextView! { get set }
}

extension NewsCell {
    func loadFooterFrom(_ news:News) {
        likesLabel?.text = news.likes?.count?.formatUsingAbbrevation() ?? "0"
        commentsLabel?.text = news.comments?.count?.formatUsingAbbrevation() ?? "0"
        repostsLabel.text = news.reposts?.count?.formatUsingAbbrevation() ?? "0"
    }
    func loadTextFrom(_ news:News) {
        let text = news.text ?? ""
        textView?.text = text.replacingOccurrences(of: "<br>", with: "")
    }
}

