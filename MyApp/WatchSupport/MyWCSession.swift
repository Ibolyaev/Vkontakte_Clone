//
//  WCSession.swift
//  MyApp
//
//  Created by Игорь Боляев on 27.02.2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation
import WatchConnectivity

class MyWCSession: NSObject, WCSessionDelegate {

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
}

