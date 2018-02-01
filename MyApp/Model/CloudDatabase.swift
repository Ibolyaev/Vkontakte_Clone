//
//  CloudDatabase.swift
//  MyApp
//
//  Created by Ronin on 01/02/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CloudDatabase {
    private lazy var ref = Database.database().reference()
    func saveUser(_ user: User) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.ref.child("Users").child(String(user.id)).setValue(["name":user.name])
        }
    }
    func userDidJoinGroup(_ group:Group) {
        guard let userId = AppState.shared.userId else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.ref.child("Users").child("\(userId)").child("groups").child(String(group.id)).setValue(["name":group.name])
        }
    }
}

