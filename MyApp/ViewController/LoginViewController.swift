//
//  ViewController.swift
//  MyApp
//
//  Created by Ronin on 16/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let authService = AuthService()
    override var preferredStatusBarStyle: UIStatusBarStyle { return  .default }
    
    func loginCompletion(user:User?, error:Error?) {
        if user != nil {
            performSegue(withIdentifier: Constants.SegueIdentifiers.mainScreen, sender: nil)
        } else {
            print(error ?? "Login error")
        }
        
    }
    
    @IBAction func sighInTouchUpInside(_ sender: UIButton) {
        let url = VKontakteAPI.authRequest()
        authService.currentViewController = self
        authService.loginCompletion = loginCompletion
        authService.showSafari(url: url)
    }
}
