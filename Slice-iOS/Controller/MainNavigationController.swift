//
//  MainNavigationController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/24/21.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    var userLoggedIn: Bool = {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.value(forKey: "token")
        print(token as Any)
        if token != nil {
            print("User is logged in.")
            return true
        } else {
            print("User is not logged in.")
            return false
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.navigationBar.prefersLargeTitles = true
        checkUserActivity()
    }
    
    fileprivate func checkUserActivity() {
        if userLoggedIn {
            self.pushViewController(showHomeViewController(), animated: true)
        } else {
            self.pushViewController(showStarterViewController(), animated: true)
        }
    }
    
    func showStarterViewController() -> UIViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let starterViewController = mainStoryboard.instantiateViewController(identifier: "starterViewController") as! StarterViewController
        return starterViewController
        
    }
    
    @objc func showHomeViewController() -> UIViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(identifier: "homeViewController") as! HomeViewController
        return homeViewController
    }
}
