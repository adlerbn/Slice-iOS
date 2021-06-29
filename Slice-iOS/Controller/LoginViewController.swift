//
//  LoginViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: CustomButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var backButton: UIButton!
    
    var emailIsValid: Bool {
        get {
            if let text = emailTextField.text {
                return Validator.isValidEmail(text)
            } else {
                return false
            }
        }
    }
    
    var starterViewControllerDelegate: StarterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        initialize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let verificationVC = segue.destination as! VerificationViewController
        if segue.identifier == "goToVerification" {
            verificationVC.email = emailTextField.text
        }
    }
    
    
    
}

//MARK: - Help Method
extension LoginViewController {
    func initialize() {
        addTarget()
        emailTextField.configure()
    }
    
    func initializeUI() {
        setShadow()
    }
    
    func setShadow() {
        signInButton.layer.shadowColor = UIColor.systemGray4.cgColor
        signInButton.layer.shadowOpacity = 0.3
        signInButton.layer.shadowOffset = .zero
        signInButton.layer.shadowRadius = 3
    }
    
    func addTarget() {
        registerButton.addTarget(self, action: #selector(goToRegisterViewController), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(dismissBackButton), for: .touchUpInside)
    }
    
    @objc func dismissBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func goToRegisterViewController() {
        print("Dismissed LoginViewController")
        navigationController?.popToRootViewController(animated: true)
        let vc = StarterViewController()
        starterViewControllerDelegate = vc
        starterViewControllerDelegate?.goToRegisterViewController()
    }
    
    func checkTextField(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty, emailIsValid {
            signInButton.enableButton()
            emailTextField.clearErrorText()
        } else {
            signInButton.disableButton()
            emailTextField.setErrorText(text: "Invalid")
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailTextField.tintColor = UIColor(named: "Color-1")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailTextField.tintColor = UIColor.label
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkTextField(textField)
    }
}
