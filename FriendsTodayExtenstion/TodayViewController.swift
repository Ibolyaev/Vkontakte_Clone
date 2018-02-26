//
//  TodayViewController.swift
//  FriendsTodayExtenstion
//
//  Created by Игорь Боляев on 22.02.2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit
import NotificationCenter
import SDWebImage

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var lastFriends =  [[String:String]]()
    @IBOutlet var tableView: UITableView!
    var defaults = UserDefaults(suiteName: "group.lastFriends")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        self.preferredContentSize.height = 400
        loadData()
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    func loadData() {
        if let data = defaults?.value(forKey: "lastFriends") as? [[String:String]] {
            lastFriends = data
        }
    }
}
extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastFriends.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        let friend = lastFriends[indexPath.row]
        cell.textLabel?.text = friend["name"]
        if let urlString = friend["photoURL"], let url = URL(string: urlString) {
            cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "Vk"), options: SDWebImageOptions.highPriority, completed: nil)
            cell.imageView?.contentMode = .scaleAspectFit
        }
        
        return cell
    }
}
