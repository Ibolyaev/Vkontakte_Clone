//
//  UserStroryTableViewController.swift
//  MyApp
//
//  Created by Ronin on 18/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class FriendsTableViewController: UITableViewController, AlertShower {

    private var friends: Results<User>?
    let clientVk = VKontakteAPI()
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocalData()
        guard let friends = friends else {
            return
        }
        // Observe Results Notifications
        notificationToken = friends.observe { [weak self] (changes: RealmCollectionChange) in
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
                self?.showError(with: error.localizedDescription)
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNetworkData()
    }
    
    @IBAction func quitTouchUpInside(_ sender: UIBarButtonItem) {
        AppState.shared.quit(self)
    }
    func loadLocalData() {
        do {
            let realm = try Realm()
            friends = realm.objects(User.self)
        } catch let error {
            showError(with: error.localizedDescription)
        }
    }
    
    func loadNetworkData() {
        clientVk.getUserFriends() {[weak self](friends, error) in
            if let loadedFriends = friends {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(loadedFriends, update: true)
                    }
                } catch let error {
                    self?.showError(with: error.localizedDescription)
                }
            } else {
                self?.showError(with: error?.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.reuseIdentifier, for: indexPath) as? FriendTableViewCell
        guard let friendCell = cell, let friends = friends else { return UITableViewCell() }
        
        let friend = friends[indexPath.row]
        friendCell.friend = friend        
        
        return friendCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.showFriendPictures,
            let friend = (sender as? FriendTableViewCell)?.friend,
            let friendPhotoCollectionView = segue.destination as? FriendPhotoCollectionViewController {
            friendPhotoCollectionView.friend = friend
        }
    }
}
