//
//  PostTableViewCell.swift
//  Fridgify
//
//  Created by Murad Bayramli on 13.02.22.
//

import UIKit
import SkeletonView

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var postDescription: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var savePostButton: UIButton!
    var isLiked: Bool = false
    
    
    
    static let identifier = "PostTableViewCell"
    let id: Int = 0
    
    
    static func nib() -> UINib {
        return UINib(nibName: "PostTableViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
        isSkeletonable = true
        cardView.isSkeletonable = true
        userImageView.isSkeletonable = true
        postImageView.isSkeletonable = true
        usernameLabel.isSkeletonable = true
        likesLabel.isSkeletonable = true
        postDescription.isSkeletonable = true
        likesButton.isSkeletonable = false
        commentsButton.isSkeletonable = false
        shareButton.isSkeletonable = false
        savePostButton.isSkeletonable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
    }
    
    func configure(with model: Post){
        self.cardView.layer.shadowPath = UIBezierPath(rect: self.cardView.bounds).cgPath
        self.cardView.layer.shadowRadius = 8
        self.cardView.layer.shadowOffset = .zero
        self.cardView.layer.shadowOpacity = 0.4
        //self.likesLabel.text = "\(model.likes) Likes"
        self.usernameLabel.text = "username"   // model.username
        
        self.userImageView.image = UIImage(named: "murad")
        self.postImageView.image = UIImage(named: "dolma")
        self.postDescription.text = "My new Recipy"  //model.postDescription
        //self.postDescription.text = model._id
        
        
//        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
//        let unlikedImage = UIImage(systemName: "heart", withConfiguration: largeConfig)
//        let likedImage = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        
//        if hasUserLiked {
//            self.likesButton.setImage(likedImage, for: .normal)
//            self.likesButton.tintColor = .red
//        } else {
//            self.likesButton.setImage(unlikedImage, for: .normal)
//            self.likesButton.tintColor = .black
//        }
        
        
        
        
    }
    
    @IBAction func likesButtonPressed(_ sender: UIButton!) {
        
        
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        let unlikedImage = UIImage(systemName: "heart", withConfiguration: largeConfig)
        let likedImage = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)


        if sender.tintColor != .red {
            sender.setImage(likedImage, for: .normal)
            sender.tintColor = .red
            self.isLiked = true
        } else {
            sender.tintColor = .black
            sender.setImage(unlikedImage, for: .normal)
            self.isLiked = false
        }

        sender.animateButton()

        
    }

    //MARK: - Save Post Button Pressed
    @IBAction func savePostButtonPressed(_ sender: UIButton!) {
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        
        let unSavedImage = UIImage(systemName: "bookmark", withConfiguration: largeConfig)
        let savedImage = UIImage(systemName: "bookmark.fill", withConfiguration: largeConfig)
        

        if sender.tintColor != .orange {
            sender.setImage(savedImage, for: .normal)
            sender.tintColor = .orange
        } else {
            sender.tintColor = .black
            sender.setImage(unSavedImage, for: .normal)
        }

        sender.animateButton()
    }
    
}

extension UIButton {
    func animateButton(){
            UIView.animate(withDuration: 0.1, animations: {
              //let newImage = self.isLiked ? self.likedImage : self.unlikedImage
              self.transform = self.transform.scaledBy(x: 0.8, y: 0.8)
              //self.setImage(newImage, for: .normal)
            }, completion: { _ in
              
              UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
              })
            })
    }
}
