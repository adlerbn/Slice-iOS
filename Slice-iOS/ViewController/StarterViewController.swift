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
    func changeRootViewController()
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
}

extension StarterViewController: StarterViewControllerDelegate {
    func changeRootViewController() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        UIApplication.shared.windows.first?.rootViewController = homeViewController
    }
    
    func goToRegisterViewController() {
        print("goToRegister with delegate")
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    func goToSignInViewController() {
        print("goToSignIn with delegate")
        performSegue(withIdentifier: "goToSignIn", sender: self)
    }
}
