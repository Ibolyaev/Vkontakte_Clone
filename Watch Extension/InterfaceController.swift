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
    
    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            session.delegate = self
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            session.sendMessage(["foo":"bar"], replyHandler: { (replyData) in
                print(replyData)
            }, errorHandler: { (error) in
                print(error)
            })
        }
    }

}
