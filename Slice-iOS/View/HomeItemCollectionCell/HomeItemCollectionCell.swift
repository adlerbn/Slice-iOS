//
//  ItemCollectionCell.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/13/21.
//

import UIKit

class HomeItemCollectionCell: UICollectionViewCell {
    
    static let identifier: String = "HomeItemCollectionCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeItemCollectionCell", bundle: nil)
    }
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var homeItemImageView: UIImageView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var homeItemTitleLabel: UILabel!
    @IBOutlet weak var homeItemPriceLabel: UILabel!
    @IBOutlet weak var discountIcon: UIImageView!
    @IBOutlet weak var homeItemDiscountLabel: UILabel!
    @IBOutlet weak var homeItemScoreLabel: UILabel!
    
    var foodId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
