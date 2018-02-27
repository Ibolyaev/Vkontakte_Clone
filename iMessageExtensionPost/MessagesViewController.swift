//
//  MessagesViewController.swift
//  iMessageExtensionPost
//
//  Created by Ronin on 26/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit
import Messages
import RealmSwift
import SDWebImage

class MessagesViewController: MSMessagesAppViewController {
    
    var lastNews: Results<LastNews>?
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        loadData()
    }
    
    func send(_ news: LastNews) {
        let layout = MSMessageTemplateLayout()
        layout.imageTitle = news.title
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
    }
    func loadData() {
        guard let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.MyApp.LastNews") else {
            assert(false, "group.MyApp.LastNews - Shared group must be in App")
            return
        }        
        do {
            let realm = try Realm(fileURL: directory.appendingPathComponent("db.realm"))
            lastNews = realm.objects(LastNews.self)
        } catch let error {
            print(error.localizedDescription)
        }
    }  
}

extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let news = lastNews?[indexPath.row] else { return }
        send(news)
    }
}

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastNews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageViewCell.identefier, for: indexPath) as? MessageViewCell, let news = lastNews?[indexPath.row] else { return UITableViewCell() }
       
        cell.newsTitleLabel.text = news.title
        cell.newsTextLabel?.text = news.text
        if let url = URL(string: news.photoUrl) {
          cell.newsImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Vk"), options: SDWebImageOptions.highPriority, completed: nil)
        }
        return cell
    }  
}
