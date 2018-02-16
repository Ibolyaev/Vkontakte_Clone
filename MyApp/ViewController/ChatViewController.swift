//
//  ChatViewController.swift
//  MyApp
//
//  Created by Ronin on 16/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, AlertShower {

    var messages = [Message]() {
        didSet {
            tableView?.reloadData()
        }
    }
    var friend: User? {
        didSet {
            loadMessages()
        }
    }
    let clientVk = VKontakteAPI()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
        tableView.register(UINib(nibName: "SenderChatTableViewCell", bundle: nil), forCellReuseIdentifier: SenderChatTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "ReceiverChatTableViewCell", bundle: nil), forCellReuseIdentifier: ReceiverChatTableViewCell.reuseIdentifier)
        
    }
    private func loadMessages() {
        guard let friend = friend else { return }
        
        clientVk.getMessageHistroryWith(user: friend) {[weak self] (messages, error) in
            if let messages = messages {
                DispatchQueue.main.async {
                    self?.messages = messages
                }
            } else {
                self?.showError(with: error?.localizedDescription)
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var message = messages[indexPath.row]
        var chatCell:ChatCell?
        if message.userID == message.fromID {
            chatCell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath) as? SenderChatTableViewCell
        } else {
            chatCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatTableViewCell", for: indexPath) as? ReceiverChatTableViewCell
        }
        guard let cell = chatCell else { return UITableViewCell() }
        
        cell.messageTextView?.text = message.body
        cell.timeStemp?.text = message.fromattedDate
        
        return cell as! UITableViewCell
    }
}
