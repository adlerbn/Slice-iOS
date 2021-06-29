//
//  ChangingViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/24/21.
//

import UIKit



class ChangingViewController {
    static func changeRoot(rootName: String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: rootName)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    
    
}
