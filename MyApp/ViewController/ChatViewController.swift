//
//  ChatViewController.swift
//  MyApp
//
//  Created by Ronin on 16/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    let messages = ["Hello","How are you", "Im good", "I was going to say bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla....."]
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        tableView.register(UINib(nibName: "SenderChatTableViewCell", bundle: nil), forCellReuseIdentifier: SenderChatTableViewCell.reuseIdentifier)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as? SenderChatTableViewCell else {
            return UITableViewCell()
        }
        cell.messageTextView?.text = messages[indexPath.row]
        cell.timeStemp?.text = "11:14"
        cell.changeImage("chat_bubble_received")
        return cell
    }
}
