//
//  ViewController.swift
//  Fridgify
//
//  Created by Murad Bayramli on 05.02.22.
//

import UIKit
import Lottie
import Alamofire
import SCLAlertView
//import XCTest



class ViewController: UIViewController {
    
    @IBOutlet weak var fridgiGOLabel: UILabel!
    @IBOutlet weak var welcomeFood: AnimationView!
    
    private lazy var showWelcomeScreens: Bool = setWelcomeBool()
        
    
    
    func setWelcomeBool () -> Bool {
        if ((UserDefaults.standard.object(forKey: "showWelcomeScreens")) == nil) {
            UserDefaults.standard.set(true, forKey: "showWelcomeScreens")
            return true
        } else {
            UserDefaults.standard.set(false, forKey: "showWelcomeScreens")
            return UserDefaults.standard.bool(forKey: "showWelcomeScreens")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentLoginPage), name: NSNotification.Name(rawValue: "PresentLoginPage"), object: nil)
        
        fridgiGOLabel.isHidden = true
        fridgiGOLabel.font = UIFont(name: "Croogla4F", size: 57.0)
        
        
        welcomeFood.contentMode = .scaleAspectFit
        welcomeFood.loopMode = .playOnce
        
        welcomeFood.animationSpeed = 0.7
        welcomeFood.backgroundBehavior = .pauseAndRestore
        
        welcomeFood.play(completion: {_ in
            self.fridgiGOLabel.alpha = 0
            self.fridgiGOLabel.isHidden = false
            self.fridgiGOLabel.fadeIn()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute: {
                if (self.showWelcomeScreens){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let welcomeNC = storyboard.instantiateViewController(withIdentifier: K.welcomeNC)
                    welcomeNC.modalPresentationStyle = .fullScreen
                    self.present(welcomeNC, animated: true, completion: nil)
                } else {
                    (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
                    
                    // Check if user token is still valid for direct log in
                    
                    if (UserDefaults.standard.object(forKey: "token") == nil){
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginNC = storyboard.instantiateViewController(withIdentifier: K.loginNC)
                        loginNC.modalPresentationStyle = .fullScreen
                        self.present(loginNC, animated: true, completion: nil)
                    } else {
                        let params : [String:String] = ["token":UserDefaults.standard.string(forKey: "token")!]

                        AF.request("\(K.apiBaseURL)/auth/api/v1/posts", method: .get, parameters: params).responseJSON { response in
                                print(response)
                            switch response.result {
                            case .success(_):
                                let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                                if let jsonTopLevel = json as? [String:Any] {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let res = jsonTopLevel["status"]!
                                    let statusString = "\(res)"
                                    if (statusString.toBool()!){
                                        let mainNC = storyboard.instantiateViewController(withIdentifier: K.mainNC)
                                        mainNC.modalPresentationStyle = .fullScreen
                                        self.present(mainNC, animated: true, completion: nil)
                                    } else {
                                        let loginNC = storyboard.instantiateViewController(withIdentifier: K.loginNC)
                                        loginNC.modalPresentationStyle = .fullScreen
                                        self.present(loginNC, animated: true, completion: nil)
                                    }
                                }
                            case .failure(let err):
                                SCLAlertView().showError("Error", subTitle: err.localizedDescription)
                                UserDefaults.standard.removeObject(forKey: "token")
                            }


                        }
                    }

                    
                }
            })
        })
        
        
        
    }
    
    @objc func presentLoginPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNC = storyboard.instantiateViewController(withIdentifier: K.loginNC)
        loginNC.modalPresentationStyle = .fullScreen
        self.present(loginNC, animated: true, completion: nil)
    }


}

