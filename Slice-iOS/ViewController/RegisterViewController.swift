//
//  ViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerButton: CustomButton!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var starterViewControllerDelegate: StarterViewControllerDelegate?
    var emailIsValid: Bool {
        get {
            if let text = emailTextField.text {
                return Validator.isValidEmail(text)
            } else {
                return false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeUI()
        initialize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let verificationVC = segue.destination as! VerificationViewController
        if segue.identifier == "goToVerification" {
            verificationVC.email = emailTextField.text
            verificationVC.name = nameTextField.text
        }
    }
}

//MARK: - Help Methodes
extension RegisterViewController {
    func initialize() {
        addTarget()
        emailTextField.configure()
        nameTextField.configure()
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
    
    func addTarget() {
        signInButton.addTarget(self, action: #selector(goToSignInViewController), for: .touchUpInside)
    }
    
    @objc func goToSignInViewController() {
        navigationController?.popViewController(animated: true)
        starterViewControllerDelegate?.goToSignInViewController()
    }
    
    func checkTextField(_ textField: UITextField) {
        
        
        if let text = textField.text, !text.isEmpty, emailIsValid {
            registerButton.enableButton()
            emailTextField.clearErrorText()
        } else {
            registerButton.disableButton()
            emailTextField.setErrorText(text: "Invalid")
        }
    }
}

//MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case emailTextField:
            emailTextField.tintColor = UIColor(named: "Color-1")
        case nameTextField:
            nameTextField.tintColor = UIColor(named: "Color-1")
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case emailTextField:
            emailTextField.tintColor = UIColor.label
        case nameTextField:
            nameTextField.tintColor = UIColor.label
        default:
            break
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkTextField(textField)
    }
}
