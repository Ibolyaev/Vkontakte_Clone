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

class NewsTableViewController: UITableViewController, AlertShower {
    
    var newsResponse:NewsResponse? {
        didSet {
            items = newsResponse?.items?.filter({ (news) -> Bool in
                return news.type != "wall_photo"
            })
        }
    }
    
    var items:[News]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        
        tableView.register(UINib(nibName: "NewsWithPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: NewsWithPhotoTableViewCell.reuseIdentifier)
        //tableView.register(UINib(nibName: "NewsPhotoUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: NewsPhotoUpdateTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNews()
    }
    
    private func loadNews() {
        VKontakteAPI().getUserNewsFeed() {[weak self](news, error) in
            if let loadedNews = news {
                DispatchQueue.main.async {
                    self?.newsResponse = loadedNews
                }
            } else {
                self?.showError(with: error?.localizedDescription) 
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let items = items,
            let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsWithPhotoTableViewCell.reuseIdentifier, for: indexPath) as? NewsWithPhotoTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        if item.source_id < 0 {
            let sourceProfile = newsResponse?.groups?.first() {$0.gid == (-item.source_id)}
            newsCell.group = sourceProfile
        } else {
            let sourceProfile = newsResponse?.profiles?.first() {$0.uid == item.source_id}
            newsCell.profile = sourceProfile
        }
        newsCell.confugurateCell(news: item)
        
        return newsCell
    }
}
