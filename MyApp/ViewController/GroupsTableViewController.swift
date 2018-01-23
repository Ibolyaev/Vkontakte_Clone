//
//  GroupsTableViewController.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Alamofire

class GroupsTableViewController: UITableViewController, UISearchBarDelegate {

    var groups: [Group] = [Group]()
    var filteredGroups: [Group] = [Group]()
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
        guard let token = AppState.shared.token else { return }
        
        VKontakteAPI().getGroups(" ", userToken: token) {[weak self] (groups, error) in
            if error == nil {
                if let loadedGroups = groups {
                    DispatchQueue.main.async {
                        self?.filteredGroups = loadedGroups
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        guard let token = AppState.shared.token, searchText != "" else { return }
        
        VKontakteAPI().getGroups(searchText, userToken: token) {[weak self] (groups, error) in
            if error == nil {
                if let loadedGroups = groups {
                    DispatchQueue.main.async {
                        self?.filteredGroups = loadedGroups
                        self?.groups = loadedGroups
                        self?.tableView.reloadData()
                    }
                }
            }
        }
        
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
