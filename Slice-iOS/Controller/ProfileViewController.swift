//
//  ProfileViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/28/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()

        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        let name = userDefaults.value(forKey: "name") as? String
        let email = userDefaults.value(forKey: "email") as? String
        
        
        nameLabel.text = name
        emailLabel.text = email
    }
}

//MARK: - Help Method
extension ProfileViewController {
    func initialize() {
        addTarget()
    }
    
    func initializeUI() {
        setShadow()
    }
    
    func setShadow() {
        logoutButton.layer.shadowColor = UIColor.systemGray4.cgColor
        logoutButton.layer.shadowOpacity = 0.3
        logoutButton.layer.shadowOffset = .zero
        logoutButton.layer.shadowRadius = 3
    }
    
    func addTarget() {
        logoutButton.addTarget(self, action: #selector(loadingChangeRoot), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(dismissBackButton), for: .touchUpInside)
    }
    
    @objc func dismissBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeRootViewController() {
        clearUserDefaults()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNavigationController = mainStoryboard.instantiateViewController(identifier: "MainNavigationController") as! MainNavigationController
        self.view.window?.rootViewController = mainNavigationController
        self.view.window?.makeKeyAndVisible()
    }
    
    func clearUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "token")
        userDefaults.removeObject(forKey: "name")
        userDefaults.removeObject(forKey: "email")
    }
    
    @objc func loadingChangeRoot() {
        let loader = self.loadAlert(message: "Log Out", animationName: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            loader.dismiss(animated: true)
        }
        
        perform(#selector(changeRootViewController), with: self, afterDelay: 2)
    }
}
