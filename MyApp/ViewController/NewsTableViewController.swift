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
    
    var realData = [News]() {
        didSet {
            tableView.reloadData()
        }
    }
    var clientVK = VKontakteAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        loadNews() 
        tableView.register(UINib(nibName: "NewsWithPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: NewsWithPhotoTableViewCell.reuseIdentifier)
        //tableView.register(UINib(nibName: "NewsPhotoUpdateTableViewCell", bundle: nil), forCellReuseIdentifier: NewsPhotoUpdateTableViewCell.reuseIdentifier)
    }
    
    private func loadNews() {
        guard let token = AppState.shared.token else { return }
        
        clientVK.getUserNewsFeed(token) {[weak self](news, error) in
            if let loadedNews = news {
                self?.realData = loadedNews
                /*do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(loadedFriends, update: true)
                    }
                } catch let error {
                    AppState.shared.showError(with: error.localizedDescription, viewController: self)
                }*/
            } else {
                AppState.shared.showError(with: error?.localizedDescription, viewController: self)
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = realData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsWithPhotoTableViewCell.reuseIdentifier, for: indexPath) as? NewsWithPhotoTableViewCell
        
        guard let newsCell = cell else { return UITableViewCell()}
        
        newsCell.confugurateCell(news: item)
        
        return newsCell
        
    }
    
}
