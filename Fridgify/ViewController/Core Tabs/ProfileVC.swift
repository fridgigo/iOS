//
//  ProfileVC.swift
//  Fridgify
//
//  Created by Murad Bayramli on 13.02.22.
//

import Foundation
import UIKit
import Alamofire
import SCLAlertView


class ProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userBackground: UIImageView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var posts = [Post]()
    var extraView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getUserPosts()
        
        postsCollectionView.register(UserPostCollectionViewCell.self,
                                     forCellWithReuseIdentifier: UserPostCollectionViewCell.identifier)
        postsCollectionView.register(ProfileHeaderReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderReusableView.identifier)
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        view.backgroundColor = UIColor(named: "MainBackground")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        
//        userImage.layer.cornerRadius = 40
//        userImage.layer.borderWidth = 4
//        userImage.layer.borderColor = UIColor.white.cgColor
        
//        usernameLabel.text = UserDefaults.standard.string(forKey: "username")
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func animateZoomforCell(zoomCell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            let x = zoomCell.frame.size.width / 2
            let y = zoomCell.frame.size.height / 1.5
            zoomCell.transform = CGAffineTransform(scaleX: x, y: y)
        }, completion: {(finished: Bool) -> Void in
            
            self.animateZoomforCellremove(zoomCell: zoomCell)
        })
    }
    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            zoomCell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: {(finished: Bool) -> Void in
            
            self.extraView.removeFromSuperview()
            self.postsCollectionView.reloadData()
            
        })
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "traitCollectionDidChange"), object: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPostCollectionViewCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/3)-3,
                      height: (view.frame.size.width/3)-3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.postsCollectionView.deselectItem(at: indexPath, animated: true)
        self.animateZoomforCell(zoomCell: collectionView.cellForItem(at: indexPath)!)
        extraView.backgroundColor = .white
        extraView.addSubview(collectionView.cellForItem(at: indexPath)!)
        self.view.addSubview(extraView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderReusableView.identifier, for: indexPath) as! ProfileHeaderReusableView
        header.configure()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 220)
    }
    
    
    
    func getUserPosts(){
        // GET THE FEED FROM API
        let defaults = UserDefaults.standard
        let params : [String:String] = ["token":defaults.string(forKey: "token")!]
        AF.request("\(K.apiBaseURL)/auth/api/v1/posts", method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(_):
                
                var postsResponse: PostsResponse?
                
                do{
                    postsResponse = try JSONDecoder().decode(PostsResponse.self, from: response.data!)
                    if let postsResponse = postsResponse {
                        print("postsResponse: \(postsResponse)")
                        self.posts = postsResponse.posts
                       
                        var filteredPosts = [Post]()
                        for post in postsResponse.posts {
                            
                            if (post.username == defaults.string(forKey: "username")){
                                filteredPosts.append(post)
                            }
                        }
                        self.posts = filteredPosts
                        print("Filtered Posts: \(filteredPosts)")
                        print("Post Count\(filteredPosts.count)")
                        
                    } else {
                        print("Failed to parse")
                    }
                } catch {
                    print("Error: \(error)")
                }
        
                break;
            case .failure(let err):
                SCLAlertView().showError("Error", subTitle: err.localizedDescription)
                break;
            }
        }
        
    }
    
    
    
}


