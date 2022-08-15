//
//  HomeVC.swift
//  Fridgify
//
//  Created by Murad Bayramli on 13.02.22.
//

import Foundation
import UIKit
import Alamofire
import SCLAlertView
import SkeletonView
import DGElasticPullToRefresh


class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate,  SkeletonTableViewDataSource {
    
    var receipts = [ReceiptPost]()
    //var userLikes: [Bool] = [Bool]()
    var likedPostObjectIDs: [Int:String] = [Int:String]()
    var posts: [Post] = [Post]()
    var showSkeleton: Bool = true
    
    var categoryModels = [RecipeCategoryModel]()
    @IBOutlet weak var table: UITableView!
    let refreshControl = UIRefreshControl()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryModels.append(RecipeCategoryModel(image: UIImage(named: K.breakfast)!, labelText: K.breakfast))
        categoryModels.append(RecipeCategoryModel(image: UIImage(named: K.dessert)!, labelText: K.dessert))
        categoryModels.append(RecipeCategoryModel(image: UIImage(named: K.dinner)!, labelText: K.dinner))
        categoryModels.append(RecipeCategoryModel(image: UIImage(named: K.fastFood)!, labelText: K.fastFood))
        categoryModels.append(RecipeCategoryModel(image: UIImage(named: K.lunch)!, labelText: K.lunch))
        categoryModels.append(RecipeCategoryModel(image: UIImage(named: K.snacks)!, labelText: K.snacks))
        categoryModels.append(RecipeCategoryModel(image: UIImage(named: K.soups)!, labelText: K.soups))
        categoryModels.append(RecipeCategoryModel(image: UIImage(named: K.supper)!, labelText: K.supper))
        
        let gradient = UIImageView(image: UIImage(named: "gradient"))
        gradient.contentMode = .scaleToFill
        table.backgroundView = gradient
        
        refreshFeed()
//        getFeed()
//        refreshControl.attributedTitle = NSAttributedString(string: "🍗")
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        
        table.rowHeight = 488
        table.estimatedRowHeight = 488
//        table.refreshControl = refreshControl
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white //UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        table.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false){ (timer) in
                self?.table.beginUpdates()
                self?.getFeed()
                self?.table.endUpdates()
                self?.table.reloadData()
            }
            self?.table.dg_stopLoading()
        }, loadingView: loadingView)
        table.dg_setPullToRefreshFillColor(UIColor(red: 130/255.0, green: 216/255.0, blue: 190/255.0, alpha: 1.0))
        table.dg_setPullToRefreshBackgroundColor(UIColor(named: "MainBackground")!)//table.backgroundColor!)
        
        table.register(CategoryCollectionTableViewCell.nib(), forCellReuseIdentifier: CategoryCollectionTableViewCell.identifier)
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        
        view.backgroundColor = UIColor(named: "MainBackground")

        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
            
            self.table.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.85))
        })
        
    }
    
    deinit {
        table.dg_removePullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showSkeleton {
            table.isSkeletonable = true
            //table.showAnimatedSkeleton(usingColor: .concrete, transition: .crossDissolve(0.25))
            table.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .gray), animation: nil, transition: .crossDissolve(0.25))
            showSkeleton = false
        }
        
    }
    
    @objc func refreshFeed(){
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false){ (timer) in
            self.table.beginUpdates()
            self.getFeed()
            
            self.table.endUpdates()
            self.refreshControl.endRefreshing()
            self.table.reloadData()
        }
    }
    
//    @objc func likePressed(sender: UIButton){
//
//        let rowIndex: Int = sender.tag
//
//
//        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
//        let unlikedImage = UIImage(systemName: "heart", withConfiguration: largeConfig)
//        let likedImage = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
//
//
//        if sender.tintColor != .red { // User going to like the post
//
//
//            let params : [String:Any] = ["token": UserDefaults.standard.string(forKey: "token")!,
//                                            "username": UserDefaults.standard.string(forKey: "username")!,
//                                            "post_id": self.posts[rowIndex]._id]
//            AF.request("\(K.apiBaseURL)/auth/api/v1/likes/like-post", method: .post, parameters: params).responseJSON { response in
//                    print(response)
//                switch response.result {
//                case .success(_):
//                    let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
//                    if let jsonTopLevel = json as? [String:Any] {
//                        let res = jsonTopLevel["status"]!
//                        let statusString = "\(res)"
//                        if (statusString.toBool()!){
//                            sender.setImage(likedImage, for: .normal)
//                            sender.tintColor = .red
//                            self.userLikes[rowIndex] = true
//                            self.likedPostObjectIDs[rowIndex] = "\(jsonTopLevel["object_id"]!)"
//                        } else {
//                            sender.tintColor = .black
//                            sender.setImage(unlikedImage, for: .normal)
//                            self.userLikes[rowIndex] = false
//                            SCLAlertView().showError("Error", subTitle: "Could not like the post")
//                        }
//                    }
//                case .failure(let err):
//                    SCLAlertView().showError("Error", subTitle: err.localizedDescription)
//
//                }
//
//
//            }
//
//
//
//
//        } else { // User going to dislike the post
//
//
//            let params : [String:Any] = ["token": UserDefaults.standard.string(forKey: "token")!]
//            var objID: String?
//            if likedPostObjectIDs[rowIndex] != "" {
//                objID = likedPostObjectIDs[rowIndex]
//            }
//
//
//            AF.request("\(K.apiBaseURL)/auth/api/v1/likes/dislike-post/\(objID!)", method: .delete, parameters: params).responseJSON { response in
//                    print(response)
//                switch response.result {
//                case .success(_):
//                    let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
//                    if let jsonTopLevel = json as? [String:Any] {
//                        let res = jsonTopLevel["status"]!
//                        let statusString = "\(res)"
//                        if (statusString.toBool()!){
//                            sender.tintColor = .black
//                            sender.setImage(unlikedImage, for: .normal)
//                            self.userLikes[rowIndex] = false
//                            self.likedPostObjectIDs[rowIndex] = ""
//
//                        } else {
//                            sender.setImage(likedImage, for: .normal)
//                            sender.tintColor = .red
//                            //self.userLikes[rowIndex] = true
//                            SCLAlertView().showError("Error", subTitle: "Could not dislike the post")
//                        }
//                    }
//                case .failure(let err):
//                    SCLAlertView().showError("Error", subTitle: err.localizedDescription)
//
//                }
//
//
//            }
//        }
//
//        sender.animateButton()
//        self.table.reloadData()
//
//    }
    
//    func getUserLikes(){
//        // GET LIKES INFO FOR EACH POST
//        if !posts.isEmpty {
//            print("girdi!")
//            print(posts.count)
//            let count = self.posts.count-1
//            var tempLikesArr: [Bool] = [Bool]()
//            var tempLikedObjectsDict: [Int:String] = [Int:String]()
//            for i in 0...count {
//
//                let defaults = UserDefaults.standard
//                let params: [String:String] = ["token": defaults.string(forKey: "token")!,
//                                                "username": defaults.string(forKey: "username")!,
//                                                "post_id": posts[i]._id]
//
//                AF.request("\(K.apiBaseURL)/auth/api/v1/likes/", method: .get, parameters: params).responseJSON { response in
//
//                    switch response.result {
//
//                    case .success(_):
//
//
//                        let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
//
//                        if let jsonTopLevel = json as? [String:Any] {
//
//                            let res = jsonTopLevel["status"]!
//                            let statusString = "\(res)"
//                            if (statusString.toBool()!){
//                                tempLikesArr.append(true)
//                                tempLikedObjectsDict.updateValue("\(jsonTopLevel["object_id"]!)", forKey: i)
//                                print("tempLikesArr: ",tempLikesArr)
//                            } else {
//                                tempLikesArr.append(false)
//                            }
//                        }
//
//                        break;
//                    case .failure(let err):
//                        SCLAlertView().showError("Error", subTitle: err.localizedDescription)
//                        break;
//                    }
//                }
//            }
//            self.userLikes = tempLikesArr
//            self.likedPostObjectIDs = tempLikedObjectsDict
//        }
//        print(userLikes.count)
//        print(posts.count)
//
//    }
    
    
    func getFeed(){
        // GET THE FEED FROM API
        let defaults = UserDefaults.standard
        let params : [String:String] = ["token":defaults.string(forKey: "token")!]
        AF.request("\(K.apiBaseURL)/auth/api/v1/posts", method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(_):
                //print(JSON)
                //let response = JSON as! [String:Any]
                //let posts = response["posts"] as! [[String:Any]]
                
                
                var postsResponse: PostsResponse?
                
                do{
                    postsResponse = try JSONDecoder().decode(PostsResponse.self, from: response.data!)
                    if let postsResponse = postsResponse {
                        print("postsResponse: \(postsResponse)")
                        //self.posts.append(contentsOf: postsResponse.posts)
                        self.posts = postsResponse.posts
                        self.table.reloadData()
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
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if indexPath.row == 0 {
            return CategoryCollectionTableViewCell.identifier
        }
        
        return PostTableViewCell.identifier
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            
            let cell = table.dequeueReusableCell(withIdentifier: CategoryCollectionTableViewCell.identifier, for: indexPath) as! CategoryCollectionTableViewCell
            
            cell.configure(with: categoryModels)
            return cell
            
            
        } else {
            let cell = self.table.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.configure(with: posts[indexPath.row-1])
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.lightGray
            cell.selectedBackgroundView = backgroundView
            cell.selectionStyle = .none

            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let recipeVC = storyboard.instantiateViewController(withIdentifier: K.recipeVC)
        self.navigationController?.pushViewController(recipeVC, animated: true)
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 140
        } else {
            return 488
        }
    }
    
}


struct ReceiptPost {
    var numberOfLikes: Int
    let username: String
    let userImageName: String
    var postImageName: String
    var postDescription: String
}
