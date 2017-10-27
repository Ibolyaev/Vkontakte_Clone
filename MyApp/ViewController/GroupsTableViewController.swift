//
//  GroupsTableViewController.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GroupsTableViewController: UITableViewController, UISearchBarDelegate {

    var groups: [Group] = [Group]()
    var filteredGroups: [Group] = [Group]()
    var token:String?
    var selectedGroup:Group?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for groups"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        guard let token = token, searchText != "" else { return }
        
        let params = ["q":searchText,"access_token":token]
        
        Alamofire.request(Constants.VK.urlGroupsSearch, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] (response) in
            //print(response.result.value)
            if response.result.isSuccess {
                
                if let value = response.result.value {
                    let json = JSON(value)
                    if let result = json.dictionary {
                        if let users = result["response"]?.array {
                            self?.filteredGroups.removeAll()
                            for jsonGroup in users {
                                self?.filteredGroups.append(Group(json:jsonGroup))
                            }
                        self?.tableView.reloadData()
                        } else {
                           print(response.result.error)
                        }
                    }
                }
                
            } else {
                print(response.result.error)
            }
            
        }
        
        /*filteredGroups = groups.filter({( group : Group) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        })*/
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if isFiltering() {
            return filteredGroups.count
        } else {
            return groups.count
        }        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseIdentifier, for: indexPath) as? GroupTableViewCell
        
        guard let groupCell = cell else {
            return UITableViewCell()
        }
        let group: Group
        if isFiltering() {
            group = filteredGroups[indexPath.row]
        } else {
            group = groups[indexPath.row]
        }
        groupCell.group = group
        Alamofire.request(group.photoURL).responseData {[weak groupCell] (response) in
            if response.result.isSuccess {
                
                if let data = response.result.value {
                    if let image = UIImage(data: data) {
                        if groupCell?.group?.photoURL == response.request?.url?.absoluteString {
                            groupCell?.groupImageView?.image = image
                        }
                    }
                }
            }
        }
        return groupCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering() {
            selectedGroup = filteredGroups[indexPath.row]
        } else {
            selectedGroup = groups[indexPath.row]
            performSegue(withIdentifier: "unwindToUserGroup", sender: self)
        }
        searchController.isActive = false
        
    }
    
}


extension GroupsTableViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        if selectedGroup != nil {
            performSegue(withIdentifier: "unwindToUserGroup", sender: self)
        }
    }
}

extension GroupsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
