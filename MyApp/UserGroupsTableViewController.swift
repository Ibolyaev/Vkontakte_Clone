//
//  UserGroupsTableViewController.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

class UserGroupsTableViewController: UITableViewController {

    var userGroups: [Group] { get {
        return allGroups.filter(){$0.currentUserInGroup}
        }
    }
    
    // MARK: - TO DO
    // Need to store user groups somewheare
    
    var allGroups: [Group] = {
        return Group.demoData()
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        userGroupCell.group = userGroups[indexPath.row]

        return userGroupCell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GroupsTableViewController {
            guard var selectedGroup = sourceViewController.selectedGroup else { return }
            
            guard let indexOfSeleceted = allGroups.index(of: selectedGroup) else { return }
            
            allGroups.remove(at: indexOfSeleceted)
            selectedGroup.currentUserInGroup = true
            allGroups.append(selectedGroup)
            
            tableView.reloadData()
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            var selectedGroup = userGroups[indexPath.row]
            guard let indexOfSeleceted = allGroups.index(of: selectedGroup) else { return }
            allGroups.remove(at: indexOfSeleceted)
            selectedGroup.currentUserInGroup = false
            allGroups.append(selectedGroup)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroups" {
            //GroupsTableViewController
            if let groupsVC = segue.destination as? GroupsTableViewController {
                groupsVC.groups = allGroups.filter(){!$0.currentUserInGroup}
            }
        }
    }
 

}
