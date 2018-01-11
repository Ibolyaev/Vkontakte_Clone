//
//  NewsTableViewController.swift
//  MyApp
//
//  Created by Ronin on 08/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class NewsTableViewController: UITableViewController {
    
    var demoData = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        loadDemoData()
        tableView.register(UINib(nibName: "NewsWithPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: NewsWithPhotoTableViewCell.reuseIdentifier)
        //tableView.register(UINib(nibName: "NewsPhotoUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: NewsPhotoUpdateTableViewCell.reuseIdentifier)
    }
    
    private func loadDemoData() {
        let news1 = News()
        news1.text = "News 1"
        news1.viewed = 10
        
        let news2 = News()
        news2.text = "News 2"
        news2.viewed = 20
        
        let news3 = News()
        news3.text = "News 3"
        news3.viewed = 30
        
        let news4 = News()
        news4.text = "News 4"
        news4.viewed = 40
        
        let newsPhotoUpdate = News()
        newsPhotoUpdate.text = "News 4"
        newsPhotoUpdate.viewed = 40
        //newsPhotoUpdate.type = "photoUpdate"
        
        demoData = [news1, news2, news3, news4, newsPhotoUpdate]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = demoData[indexPath.row]
        
        switch item.type {
        case "photoUpdate":
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsPhotoUpdateTableViewCell.reuseIdentifier, for: indexPath) as? NewsPhotoUpdateTableViewCell
            cell?.confugurateCell(news:item)
            
            return cell ?? UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsWithPhotoTableViewCell.reuseIdentifier, for: indexPath) as? NewsWithPhotoTableViewCell
            cell?.confugurateCell(news:item)
            
            return cell ?? UITableViewCell()
        }
        
    }
    
}
