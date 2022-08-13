//
//  CircleRecipeCollectionViewCell.swift
//  Fridgify
//
//  Created by Murad Bayramli on 12.08.22.
//

import UIKit

class CircleRecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeCategoryImage: UIImageView!
    @IBOutlet weak var recipeCategoryLabel: UILabel!
    
    
    static let identifier = "CircleRecipeCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CircleRecipeCollectionViewCell", bundle: nil)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with model: RecipeCategoryModel) {
        recipeCategoryImage.image = model.image
        recipeCategoryImage.clipsToBounds = true
        recipeCategoryImage.contentMode = .scaleAspectFill
        recipeCategoryImage.layer.masksToBounds = true
        recipeCategoryImage.layer.cornerRadius = recipeCategoryImage.frame.height/3
        recipeCategoryImage.backgroundColor = .black
        recipeCategoryLabel.text = model.labelText
    }
    
}
