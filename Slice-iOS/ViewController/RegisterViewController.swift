//
//  ViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeUI()
    }
    
    
    func initializeUI() {
        setShadowButton()
    }
    
    func setShadowButton() {
        registerButton.layer.shadowColor = UIColor.label.cgColor
        registerButton.layer.shadowOpacity = 0.3
        registerButton.layer.shadowOffset = .zero
        registerButton.layer.shadowRadius = 3
    }
    
}

//MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneTextField:
            phoneTextField.tintColor = UIColor(named: "Color-1")
        case passwordTextField:
            passwordTextField.tintColor = UIColor(named: "Color-1")
        case confirmPasswordTextField:
            confirmPasswordTextField.tintColor = UIColor(named: "Color-1")
        default:
            return true
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneTextField:
            phoneTextField.tintColor = UIColor.label
        case passwordTextField:
            passwordTextField.tintColor = UIColor.label
        case confirmPasswordTextField:
            confirmPasswordTextField.tintColor = UIColor.label
        default:
            return true
        }
        
        return true
    }
}

