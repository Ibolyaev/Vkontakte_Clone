//
//  UserGroupsTableViewController.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserGroupsTableViewController: UITableViewController {

    var userGroups = [Group]()
    let VKClient = VKontakteAPI()
    var userToken:String?
    var userId:String?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNetworkData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func loadNetworkData() {
        
        guard let token  = AppState.shared.user?.token else { return }
        
        VKClient.getUserGroups(token) {[weak self] (groups, error) in
            if error == nil {
                if let loadedGroups = groups {
                    self?.userGroups = loadedGroups
                    self?.tableView.reloadData()
                }
            }
        }        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserGroupTableViewCell.reuseIdentifier, for: indexPath) as? UserGroupTableViewCell
        
        guard let userGroupCell = cell else {
            return UITableViewCell()
        }
        let group = userGroups[indexPath.row]
        userGroupCell.group = group
        
        Alamofire.request(group.photo.url).responseData {[weak userGroupCell] (response) in
            if response.result.isSuccess {
                
                if let data = response.result.value {
                    if let image = UIImage(data: data) {
                        if userGroupCell?.group?.photo.url == response.request?.url?.absoluteString {
                            userGroupCell?.groupImageView?.image = image
                            userGroupCell?.group?.photo.image = image
                        }
                    }
                }
            }
        }

        return userGroupCell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? GroupsTableViewController {
            guard let selectedGroup = sourceViewController.selectedGroup else { return }
            
            selectedGroup.currentUserInGroup = true
            userGroups.append(selectedGroup)
            // TODO: Реализовать подписку на группу
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: Реализовать отписку от группы
        }
    }
}
