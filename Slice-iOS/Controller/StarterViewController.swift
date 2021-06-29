//
//  StarterViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

protocol StarterViewControllerDelegate {
    func goToRegisterViewController()
    func goToSignInViewController()
}

class StarterViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var loginViewController = LoginViewController()
    var registerViewController = RegisterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        initializeDelegate()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem?.tintColor = .label
    }
    
    func initializeDelegate() {
        loginViewController.starterViewControllerDelegate = self
        registerViewController.starterViewControllerDelegate = self
    }
    
    func initializeUI() {
        setShadow()
    }
    
    func setShadow() {
        registerButton.layer.shadowColor = UIColor.systemGray4.cgColor
        registerButton.layer.shadowOpacity = 0.3
        registerButton.layer.shadowOffset = .zero
        registerButton.layer.shadowRadius = 3
    }
    
    func goToRegister() {
        
    }
    
    func goToLogin() {
        
    }
}

extension StarterViewController: StarterViewControllerDelegate {
    func goToRegisterViewController() {
        print("goToRegister with delegate")
        goToRegister()
    }
    
    func goToSignInViewController() {
        print("goToSignIn with delegate")
        goToLogin()
    }
}
