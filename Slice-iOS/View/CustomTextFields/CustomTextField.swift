//
//  File.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/23/21.
//

import UIKit

class CustomTextField: UITextField {
    
    private var isConfigured = false
    var errorLabel: UILabel?
    
    func configureTextField() {
        textColor = .label
    }
    
    func configure() {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let label = createLabelError()
        errorLabel = label
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])
    }
    
    func createLabelError() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isUserInteractionEnabled = true
        return label
    }
    
    func setErrorText(text: String) {
        errorLabel?.text = text
    }
    
    func clearErrorText() {
        errorLabel?.text = .none
    }
}
