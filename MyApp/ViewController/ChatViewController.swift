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
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var newMessageTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.register(UINib(nibName: "SenderChatTableViewCell", bundle: nil), forCellReuseIdentifier: SenderChatTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "ReceiverChatTableViewCell", bundle: nil), forCellReuseIdentifier: ReceiverChatTableViewCell.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.bottomConstraint.constant -= keyboardFrame.size.height
        UIView.animate(withDuration: 0.1) {
            self.loadViewIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        UIView.animate(withDuration: 0.1) {
            self.bottomConstraint.constant += keyboardFrame.size.height
        }
        
    }
    
    private func resetUI() {
        newMessageTextField.text = ""
    }
    
    @IBAction func sendTouchUpInside(_ sender: UIButton) {
        newMessageTextField.resignFirstResponder()
        guard let message = newMessageTextField.text, let user = friend, !message.isEmpty else { return }
       
        // TODO: Start activity
        clientVk.send(message:  message, to: user) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.resetUI()
                    self?.loadMessages()
                } else {
                    self?.showError(with: error?.localizedDescription)
                }
            }
        }
    }
   
    private func loadMessages() {
        guard let friend = friend else { return }
        clientVk.getMessageHistroryWith(user: friend) {[weak self] (messages, error) in
            DispatchQueue.main.async {
                if let messages = messages {
                    self?.messages = messages.sorted {$0.date < $1.date}
                } else {
                    self?.showError(with: error?.localizedDescription)
                }
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
