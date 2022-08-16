//
//  UserPostCollectionViewCell.swift
//  Fridgify
//
//  Created by Murad Bayramli on 23.02.22.
//

import UIKit

class UserPostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserPostCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.image = UIImage(named: "xengel")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //imageView.image = nil
    }
    
   
    
    
}
