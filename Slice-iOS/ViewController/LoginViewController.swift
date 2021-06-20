//
//  LoginViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
    }

    func initializeUI() {
        setShadowButton()
    }
    
    func setShadowButton() {
        signInButton.layer.shadowColor = UIColor.label.cgColor
        signInButton.layer.shadowOpacity = 0.3
        signInButton.layer.shadowOffset = .zero
        signInButton.layer.shadowRadius = 3
    }

}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case usernameTextField:
            usernameTextField.tintColor = UIColor(named: "Color-1")
        case passwordTextField:
            passwordTextField.tintColor = UIColor(named: "Color-1")
        default:
            return true
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case usernameTextField:
            usernameTextField.tintColor = UIColor.label
        case passwordTextField:
            passwordTextField.tintColor = UIColor.label
        default:
            return true
        }
        
        return true
    }
}
