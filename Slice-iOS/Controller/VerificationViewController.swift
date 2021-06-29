//
//  VerificationViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/22/21.
//

import UIKit

class VerificationViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var validationCodeTextField: UITextField!
    @IBOutlet weak var confirmButton: CustomButton!
    @IBOutlet weak var backButton: UIButton!
    
    var email: String?
    var name: String?
    
    var apiManager: ApiManager?
    var mainNavigation = MainNavigationController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        initializeUI()
        
        sendingEmailAlert()
    }
    
}

//MARK: - Help Methodes
extension VerificationViewController {
    func initialize() {
        addTarget()
    }
    
    func initializeUI() {
        setShadow()
    }
    
    func setShadow() {
        confirmButton.layer.shadowColor = UIColor.systemGray4.cgColor
        confirmButton.layer.shadowOpacity = 0.3
        confirmButton.layer.shadowOffset = .zero
        confirmButton.layer.shadowRadius = 3
    }
    
    func addTarget() {
        confirmButton.addTarget(self, action: #selector(changeRootViewController), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(dismissBackButton), for: .touchUpInside)
    }
    
    @objc func dismissBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeRootViewController() {
        print("root changed.")
        changeRootAlert()
    }
    
    func checkTextField(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty, text.count == 6 {
            confirmButton.enableButton()
        } else {
            confirmButton.disableButton()
        }
    }
    
    func sendingEmailAlert() {
        
        DispatchQueue.main.async {
            self.verificationCodeRequest()
        }
        
        let loadingLoader = self.loadAlert(message: "Sending Verification Code", animationName: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            loadingLoader.dismiss(animated: true)
        }
    }
    
    func changeRootAlert() {
        self.finalRequest()
        let loadingLoader = self.loadAlert(message: "Verifying Your Code", animationName: .loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            loadingLoader.dismiss(animated: true)
        }

        perform(#selector(changeRootNavigationController), with: self, afterDelay: 3)
    }
    
    @objc func changeRootNavigationController() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNavigationController = mainStoryboard.instantiateViewController(identifier: "MainNavigationController") as! MainNavigationController
        self.view.window?.rootViewController = mainNavigationController
        self.view.window?.makeKeyAndVisible()
    }
}

//MARK: - API Methodes & Delegate
extension VerificationViewController: ApiManagerDelegateStarter {
    func verificationCodeRequest() {
        apiManager = ApiManager(type: .validation, httpMethod: .POST)
        guard let email = email else {
            print("Email is nil")
            return
        }
        apiManager?.validationCode(email)
        apiManager?.delegateStarter = self
    }
    
    func finalRequest() {
        guard let validationCode = validationCodeTextField.text else {
            print("VerificationCode is nil")
            return
        }
        
        guard let email = email else {
            print("Email is nil")
            return
        }
        
        if name == nil {
            print("api request login")
            apiManager = ApiManager(type: .login, httpMethod: .POST)
            apiManager?.login(email, validationCode)
        } else {
            print("api request register")
            guard let name = name else {
                print("Name is nil")
                return
            }
            apiManager = ApiManager(type: .register, httpMethod: .POST)
            apiManager?.register(name, email, validationCode)
        }
        apiManager?.delegateStarter = self
    }
    
    func didUpdateDefaultSettings(with activity: ActivityData) {
        print(activity)
        let userDefaults = UserDefaults.standard
        userDefaults.set(activity.token, forKey: "token")
        userDefaults.set(activity.user.nickname, forKey: "name")
        userDefaults.set(activity.user.email, forKey: "email")
    }
}

//MARK: - UITextFieldDelegate
extension VerificationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        validationCodeTextField.tintColor = UIColor(named: "Color-1")
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        validationCodeTextField.tintColor = UIColor.label
        return true
    }
    
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 6
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkTextField(textField)
    }
    
}
