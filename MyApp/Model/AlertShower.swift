//
//  AlertShower.swift
//  MyApp
//
//  Created by Ronin on 17/01/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit
protocol AlertShower {
    func showError(title:String, with message:String?)
}

extension AlertShower where Self:UIViewController {
    func showError(title:String = "We got a problem", with message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
