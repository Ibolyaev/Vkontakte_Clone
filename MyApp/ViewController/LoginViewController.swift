//
//  ViewController.swift
//  MyApp
//
//  Created by Ronin on 16/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import SafariServices

enum LoginError:Error {
    case wrongUsername
    case wrongPassword
    case wrongUsernameAndPassword
}

class LoginViewController: UIViewController {
    
    private let succesfullLoginName = "Ibo"
    private let successfullPassword = "123456"
    let authService = AuthService()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField?.text = succesfullLoginName
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField?.text = successfullPassword
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { return  .default }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))        
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func sighInTouchUpInside(_ sender: UIButton) {
        
        // uncomment for test
        //performSegue(withIdentifier: Constants.SegueIdentifiers.mainScreen, sender: nil)
        
        //Present safari view
        /*let url = URL(string: "https://oauth.vk.com/authorize?revoke=1&response_type=token&display=mobile&scope=email,offline,nohttps&v=5.40&redirect_uri=vk6263153://authorize&sdk_version=1.4.6&client_id=6263153")*/
        let url = VKontakteAPI.authRequest()
        authService.currentViewController = self
        authService.showSafari(url: url)
        
        return
        
        guard let username = loginTextField.text else {
            print("login text field is empty")
            return
        }
        
        guard let password = passwordTextField.text else {
            print("Password text field is empty")
            return
        }
        
        let result = loginWith(username: username, password: password)
        
        if result.success {
            print("Successfull login")
            performSegue(withIdentifier: Constants.SegueIdentifiers.mainScreen, sender: nil)
        } else {
            
            let alert = UIAlertController(title: "Login failed", message: nil, preferredStyle: .alert)
            
            if let error = result.error {
                switch error {
                case .wrongUsernameAndPassword : alert.message = "Username and password are wrong"
                case .wrongUsername : alert.message = "Username is wrong"
                case .wrongPassword : alert.message = "Password is wrong"
                
                }
            }
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
        scrollView?.contentInset = contentInset
        scrollView?.scrollIndicatorInsets = contentInset
        
    }
    
    @objc func keyboardwillHide(notification: NSNotification) {
        
        let contentInset = UIEdgeInsets.zero
        scrollView?.contentInset = contentInset
        scrollView?.scrollIndicatorInsets = contentInset
        
    }
    
    private func loginWith(username: String, password: String) -> (success: Bool,error: LoginError?)  {
        
        if username == succesfullLoginName && password == successfullPassword {
            return (true,nil)
        }
        
        if username == succesfullLoginName {
            return(false,.wrongPassword)
        }
        
        if password == successfullPassword {
            return (false,.wrongUsername)
        }
        
        return (false, .wrongUsernameAndPassword)
        
    }
    
}
