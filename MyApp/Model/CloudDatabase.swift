//
//  CloudDatabase.swift
//  MyApp
//
//  Created by Ronin on 01/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CloudKit

class CloudDatabase {
    private lazy var ref = Database.database().reference()
    func saveUser(_ user: User) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.ref.child("Users").child(String(user.id)).setValue(["name":user.name])
        }
    }
    func userDidJoinGroup(_ group:Group) {
        guard let userId = AppState.shared.userId else { return }
        saveToFirebase(group, userId: userId)
        saveToiCloud(group, userId: userId)
    }
    
    private func saveToFirebase(_ group:Group, userId: Int) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.ref.child("Users").child("\(userId)").child("groups").child(String(group.id)).setValue(["name":group.name])
        }
    }
    private func saveToiCloud(_ group:Group, userId: Int) {
        let groupRecord = CKRecord(recordType: "Groups")
        groupRecord.setValue(userId, forKey: "userId")
        groupRecord.setValue(group.screenName, forKey: "name")
        groupRecord.setValue(group.id, forKey: "id")
        
        let container = CKContainer.default()
        let dataBase = container.publicCloudDatabase
        DispatchQueue.global(qos: .userInitiated).async {
            dataBase.save(groupRecord) { (record, error) in
                if error != nil {
                    print(error!)
                }
            }
        }
    }
}

