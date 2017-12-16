//
//  UserStroryTableViewController.swift
//  MyApp
//
//  Created by Ronin on 18/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FriendsTableViewController: UITableViewController {

    private var friends = [User]()
    let VKClient = VKontakteAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if friends.count == 0 {
           updateList()
        }
    }
    
    func updateList() {
        guard let token = AppState.shared.token else { return }
        
        VKClient.getUserFriends(userToken: token) {[weak self] (friends, error) in
            if let loadedFriends = friends {
                self?.friends = loadedFriends
                self?.tableView.reloadData()
            } else {
                print(error ?? "Failed to load data")
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.reuseIdentifier, for: indexPath) as? FriendTableViewCell
        guard let friendCell = cell else { return UITableViewCell() }        
        
        let friend = friends[indexPath.row]
        friendCell.friend = friend
        
        if let url = friend.photo?.url {
            Alamofire.request(url).responseData {[weak friendCell] (response) in
                if response.result.isSuccess {
                    
                    if let data = response.result.value {
                        if let image = UIImage(data: data) {
                            if friendCell?.friend?.photo?.url == response.request?.url?.absoluteString {
                                friendCell?.profileImageView?.image = image
                            }
                        }
                    }
                }
            }
        }
        
        
        
        return friendCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFriendPictures",
            let friend = (sender as? FriendTableViewCell)?.friend,
        let friendPhotoCollectionView = segue.destination as? FriendPhotoCollectionViewController {
            friendPhotoCollectionView.friend = friend
        }
    }
    

}
