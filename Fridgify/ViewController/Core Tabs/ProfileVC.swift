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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getUserPosts()
        
        postsCollectionView.register(UserPostCollectionViewCell.self,
                                     forCellWithReuseIdentifier: UserPostCollectionViewCell.identifier)
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        
        userImage.layer.cornerRadius = 40
        userImage.layer.borderWidth = 4
        userImage.layer.borderColor = UIColor.white.cgColor
        
        usernameLabel.text = UserDefaults.standard.string(forKey: "username")
        
        
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
                      height: (view.frame.size.height/3)-3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.postsCollectionView.deselectItem(at: indexPath, animated: true)
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


