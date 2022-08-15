//
//  ProfileHeaderReusableView.swift
//  Fridgify
//
//  Created by Murad Bayramli on 14.08.22.
//

import UIKit

class ProfileHeaderReusableView: UICollectionReusableView {

    @IBOutlet weak var topBackgroundView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    static let identifier = "ProfileHeaderReusableView"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileHeaderReusableView", bundle: nil)
    }
    
    public func configure() {
        //topView.backgroundColor = UIColor(named: "darkBase")
        //profileImageView.image = UIImage(named: "murad1")
        NotificationCenter.default.addObserver(self, selector: #selector(changed), name: Notification.Name(rawValue: "traitCollectionDidChange"), object: nil)
    }
    
    @objc func changed() {
        self.profileImageView.layer.borderColor = UIColor(named: "MainBackground")!.cgColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
   
    
}
