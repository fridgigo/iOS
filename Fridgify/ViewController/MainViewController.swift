//
//  MainViewController.swift
//  Fridgify
//
//  Created by Murad Bayramli on 08.02.22.
//

import Foundation
import UIKit
//import FirebaseAuth

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        navigationItem.hidesBackButton = true
        //navigationItem.hidesSearchBarWhenScrolling = true
        
        //title = "Receipts"
        
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutUser))
//        let profileBarButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(showProfile))
//
//        navigationItem.rightBarButtonItem = profileBarButton
        //view.backgroundColor = .cyan
        
        self.navigationItem.title = "Feed"
        self.navigationController?.navigationBar.isHidden = false
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: K.homeVC)
        let postVC = storyboard.instantiateViewController(withIdentifier: K.postVC)
        let communityChatVC = CommunityChatVC()
        let fridgeVC = FridgeVC()
        let profileVC = storyboard.instantiateViewController(withIdentifier: K.profileVC)
        
       
        homeVC.title = "Home"
        postVC.title = "Post"
        communityChatVC.title = "Community"
        fridgeVC.title = "My Fridge"
        profileVC.title = "Profile"
        
        
        
        self.setViewControllers([homeVC, postVC, communityChatVC, fridgeVC, profileVC], animated: true)
        
        
        guard let items = self.tabBar.items else {return}
        
        let images = ["house", "plus.app", "message", "heart.circle", "person.circle.fill"]
        
        for i in 0..<images.count {
            items[i].image = UIImage(systemName: images[i])
        }
        
        tabBar.unselectedItemTintColor = .lightGray
        //tabBar.tintColor = UIColor(red: 34/255, green: 181/255, blue: 115/255, alpha: 1.0)
        tabBar.tintColor = UIColor(named: "fridgiBase")
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = false
        
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title {
        case "Home":
            self.navigationItem.title = "Feed"
            //self.tabBar.tintColor = UIColor(red: 34/255, green: 181/255, blue: 115/255, alpha: 1.0)
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            self.navigationController?.navigationBar.isHidden = false
            navigationItem.hidesBackButton = true
            //self.navigationItem.hidesSearchBarWhenScrolling = true
            
            break;
        case "My Fridge":
            self.navigationItem.title = "My Fridge"
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.isHidden = true
            break;
        case "Post":
            self.navigationItem.title = "Add a new Post"
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.isHidden = true
            break;
        case "Community":
            self.navigationItem.title = "Community"
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.isHidden = true
            break;
        case "Profile":
            self.navigationItem.title = "Profile"
            self.navigationController?.navigationBar.isHidden = false
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutUser))
            let profileBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(showProfile))
            
            navigationItem.rightBarButtonItem = profileBarButton
            break;
        default:
            print("default block executed")
        }
    }
    
    
    @objc func showProfile(){
        self.performSegue(withIdentifier: "MainToProfile", sender: self)
    }
    
    @objc func logoutUser(){
        
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "token")
        defaults.set("", forKey: "username")
        
        if ((self.presentingViewController as? ViewController) != nil){
            print("PRESENTING VC IS VIEWCONTROLLER !!")
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PresentLoginPage"), object: nil)
            })
        } else {
            
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoggedOut"), object: nil)
            })
        }
        
        
        
    }
    
    func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            
        }))
        return alert
    }
}

//class HomeVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//    }
//}








