//
//  ItemTableCell.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/25/21.
//

import UIKit

class ItemTableCell: UITableViewCell {

    static let identifier: String = "ItemTableCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ItemTableCell", bundle: nil)
    }
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var discountIcon: UIImageView!
    @IBOutlet weak var itemDetailsLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDiscountLabel: UILabel!
    @IBOutlet weak var itemScoreLabel: UILabel!
    
    var foodId: Int?
    
}
