//
//  AppState.swift
//  MyApp
//
//  Created by Игорь Боляев on 06.12.17.
//  Copyright © 2017 Ronin. All rights reserved.
//

import Foundation

class AppState {
    var user:User?
    static let shared = AppState()
    private init() {
    }
}
