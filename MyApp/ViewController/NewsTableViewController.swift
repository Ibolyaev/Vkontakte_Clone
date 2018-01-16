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
        guard let token = AppState.shared.token else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            let clientVK = VKontakteAPI()
            clientVK.getUserNewsFeed(token) {[weak self](news, error) in
                if let loadedNews = news {
                    DispatchQueue.main.async {
                        self?.newsResponse = loadedNews
                    }
                } else {
                    DispatchQueue.main.async {
                        AppState.shared.showError(with: error?.localizedDescription, viewController: self)
                    }
                }
            }
        }
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let items = items else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsWithPhotoTableViewCell.reuseIdentifier, for: indexPath) as? NewsWithPhotoTableViewCell
        
        guard let newsCell = cell else { return UITableViewCell()}
        let item = items[indexPath.row]
        print(item.source_id)
        if item.source_id < 0 {
            let sourceProfile = newsResponse?.groups?.first(where: { (group) -> Bool in
                group.gid == (-item.source_id)
            })
            newsCell.group = sourceProfile
        } else {
            let sourceProfile = newsResponse?.profiles?.first(where: { (group) -> Bool in
                group.uid == item.source_id
            })
            newsCell.profile = sourceProfile
        }
        newsCell.confugurateCell(news: item)
        
        return newsCell
        
    }
    
}
