//
//  Validator.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/23/21.
//

import UIKit

class Validator {
    static let EMAIL_ADDRESS =
        "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+"

    // Validator e-mail from string
    static func isValidEmail(_ value: String) -> Bool {
        let string = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let predicate = NSPredicate(format: "SELF MATCHES %@", Validator.EMAIL_ADDRESS)
        return predicate.evaluate(with: string)
    }
}
