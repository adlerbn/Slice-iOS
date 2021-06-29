//
//  UIViewController+Extension.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/21/21.
//

import UIKit
import Lottie

enum AnimationName: String {
    case loading = "loading"
    case sent = "send-email"
    case error = "error-email"
    case none = ""
}

extension UIViewController {
    func loadAlert(message: String, animationName: AnimationName) -> UIAlertController {
        let alert = UIAlertController(title: "Please Wait", message: "\(message)\n\n\n\n", preferredStyle: .alert)
        let animationView: AnimationView?
        
        animationView = .init(name: animationName.rawValue)
        animationView?.frame = CGRect(x: 110, y: 75, width: 60, height: 60)
        animationView?.loopMode = .loop
        animationView?.play()
        
        alert.view.addSubview(animationView!)
        self.present(alert, animated: true, completion: nil)
        return alert
    }
}
