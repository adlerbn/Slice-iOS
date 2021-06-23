//
//  ItemCollectionCell.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/13/21.
//

import UIKit

class HomeItemCollectionCell: UICollectionViewCell {
    
    static let identifier: String = "HomeItemCollectionCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    @IBOutlet weak var itemAddButton: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeItemCollectionCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
