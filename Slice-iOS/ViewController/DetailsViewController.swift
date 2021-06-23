//
//  DetailsViewController.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var favoriteView: UIView!
    
    @IBOutlet var shadowViews: [UIView]!
    @IBOutlet weak var topButton: UIButton!
    
    @IBOutlet weak var blurView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeUI()
    }
    
    func initializeUI() {
        setCornerRadius()
        setShadow()
    }
    
    func setCornerRadius() {
        infoView.layer.cornerRadius = 50
        infoView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        blurView.layer.cornerRadius = 15
        topButton.layer.cornerRadius = 2
    }
    
    func setShadow() {
        for shadowView in shadowViews {
            shadowView.layer.shadowColor = UIColor.systemGray4.cgColor
            shadowView.layer.shadowOpacity = 0.2
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowRadius = 5
        }
    }
    
}
