//
//  TypeCollectionCell.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/12/21.
//

import UIKit

class TypeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    
    static let identifier: String = "TypeCollectionCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TypeCollectionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func selected() {
        contentView.backgroundColor = .red
    }
    
    func deSelected() {
        contentView.backgroundColor = .blue
    }
    
}
