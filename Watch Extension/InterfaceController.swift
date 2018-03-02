//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Игорь Боляев on 27.02.2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var tableView: WKInterfaceTable!
    let session = WCSession.default
    var news = [LastNewsWatch]() {
        didSet {
            setupTable()
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
        setupTable()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func setupTable() {
        tableView.setNumberOfRows(news.count, withRowType: "News")
        
        for (index, news) in news.enumerated() {
            if let row = tableView.rowController(at: index) as? NewsRow {
               row.newsTextLabel.setText(news.text)
                row.titleTextLabel.setText(news.title)
            }
        }
    }
    
    private func sendNewsRequestMessage() {
        session.sendMessage(["LastNews": true], replyHandler: {[weak self] (replyData) in
            NSKeyedUnarchiver.setClass(LastNewsWatch.self, forClassName: "LastNewsWatch")
            for replyInfo in replyData {
                if replyInfo.key == "LastNews",
                    let newsData = replyInfo.value as? Data,
                    let news = NSKeyedUnarchiver.unarchiveObject(with: newsData) as? [LastNewsWatch] {
                    self?.news = news
                }
            }
            }, errorHandler: { (error) in
                print(error)
        })
    }
    
    @IBAction func DidTapButton() {
        sendNewsRequestMessage()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            sendNewsRequestMessage()
        }
    }

}
