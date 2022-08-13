//
//  LoginViewController.swift
//  Fridgify
//
//  Created by Murad Bayramli on 05.02.22.
//

import Foundation
import UIKit
import Lottie
import SCLAlertView


class LoginViewController: UIViewController {
    
    
    
//    @IBOutlet weak var welcomeLottie: AnimationView!
    @IBOutlet weak var loginLottie: AnimationView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//        configureLoginLottie()
//        configureWelcomeLottie()
        configureLoginButton()
        configureSingupButton()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedOut), name: NSNotification.Name(rawValue: "UserLoggedOut"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentLoginPage), name: NSNotification.Name(rawValue: "presentLoginPage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMainNC), name: NSNotification.Name(rawValue: K.notify_ShowMainNC), object: nil)
        
        loginButton.tintColor = .white
        loginButton.titleLabel?.textColor = .white
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let signinVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: K.signinVC)
        navigationController?.pushViewController(signinVC, animated: true)
        
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {

        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: K.signupVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func presentLoginPage(){
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            let signinVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: K.signinVC) as! SignInViewController
            signinVC.showEmailVerificationAlert = true
            self.navigationController?.pushViewController(signinVC, animated: true)
        })
    }

    @objc func showMainNC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNC = storyboard.instantiateViewController(withIdentifier: K.mainNC)
        mainNC.modalPresentationStyle = .fullScreen
        self.present(mainNC, animated: true, completion: nil)
    }
    
    @objc func userLoggedOut(){
        SCLAlertView().showSuccess("Success", subTitle: "You were successfully logged out")
    }
    
//    func configureWelcomeLottie(){
//        welcomeLottie.contentMode = .scaleAspectFit
//        welcomeLottie.loopMode = .playOnce
//        welcomeLottie.animationSpeed = 0.5
//        welcomeLottie.backgroundBehavior = .pauseAndRestore
//        welcomeLottie.play()
//    }
    
    
//    func configureLoginLottie(){
//        loginLottie.contentMode = .scaleAspectFit
//        loginLottie.loopMode = .loop
//        loginLottie.animationSpeed = 0.7
//        loginLottie.backgroundBehavior = .pauseAndRestore
//        loginLottie.play()
//    }
    
    func configureLoginButton(){
        loginButton.layer.cornerRadius = 25
        loginButton.layer.masksToBounds = false
        loginButton.addShadow()
        loginButton.setTitle(NSLocalizedString("SIGN IN", comment: ""), for: .normal)
        
    }
    
    func configureSingupButton(){
        signupButton.layer.cornerRadius = 25
        signupButton.layer.masksToBounds = false
        signupButton.addShadow()
        signupButton.setTitle(NSLocalizedString("Get Started", comment: ""), for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    
}


extension UIView {
    func addShadow(){
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.25
    }
    func addShadow(shadowRadius: CGFloat, shadowOpacity: Float){
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = shadowOpacity
    }
}
