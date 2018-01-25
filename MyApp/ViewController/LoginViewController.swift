//
//  ViewController.swift
//  MyApp
//
//  Created by Ronin on 16/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AlertShower {
    
    let authService = AuthService()
    override var preferredStatusBarStyle: UIStatusBarStyle { return  .default }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppState.shared.userLoggedIn = false
        AppState.shared.token = nil
    }
    
    func loginCompletion(user:User?, error:Error?) {
        if user != nil {
            performSegue(withIdentifier: Constants.SegueIdentifiers.mainScreen, sender: nil)
        } else {
            showError(title: "Login error", with: error?.localizedDescription)
        }        
    }
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {        
    }
    
    @IBAction func sighInTouchUpInside(_ sender: UIButton) {
        let url = VKontakteAPI.authRequest()
        authService.currentViewController = self
        authService.loginCompletion = loginCompletion
        authService.showSafari(url: url)
    }
}
