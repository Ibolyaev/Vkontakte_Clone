//
//  NewsCell.swift
//  MyApp
//
//  Created by Ronin on 08/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

protocol NewsCell where Self:UITableViewCell {
    func confugurateCell(news:News)
    var group:NewsGroups? { get set }
    var profile:Profiles? { get set }
}

