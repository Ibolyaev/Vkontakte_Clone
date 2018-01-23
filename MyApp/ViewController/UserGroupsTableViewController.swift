//
//  UserGroupsTableViewController.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class UserGroupsTableViewController: UITableViewController, AlertShower {

    var userGroups:Results<Group>?
    var userToken:String?
    var userId:String?
    var notificationToken: NotificationToken? = nil
 
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocalData()
        guard let userGroups = userGroups else { return }
        // Observe Results Notifications
        notificationToken = userGroups.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNetworkData()
    }
    
    func loadLocalData() {
        do {
            let realm = try Realm()
            userGroups = realm.objects(Group.self)
        } catch let error {
            showError(with:error.localizedDescription)
        }
    }
    
    func loadNetworkData() {
        VKontakteAPI().getUserGroups() {[weak self](groups, error) in
            if error == nil {
                if let loadedGroups = groups?.filter({$0.id != 0}) {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(loadedGroups, update: true)
                        }
                    } catch let error {
                        self?.showError(with:error.localizedDescription)
                    }
                }
            } else {
                self?.showError(with:error?.localizedDescription)
            }
        }        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserGroupTableViewCell.reuseIdentifier, for: indexPath) as? UserGroupTableViewCell
        
        guard let userGroups = userGroups else { return UITableViewCell() }
        
        let group = userGroups[indexPath.row]
        
        guard let userGroupCell = cell else {
            return UITableViewCell()
        }
        
        userGroupCell.group = group        
        
        return userGroupCell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if sender.source is GroupsTableViewController {
           loadNetworkData()
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
