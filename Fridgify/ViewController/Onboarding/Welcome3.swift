//
//  Welcome3.swift
//  Fridgify
//
//  Created by Murad Bayramli on 05.02.22.
//

import Foundation
import UIKit
import Lottie

class Welcome3: UIViewController {
    
    @IBOutlet weak var welcome3: AnimationView!
    @IBOutlet weak var labelWelcome3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcome3.contentMode = .scaleAspectFit
        welcome3.loopMode = .loop
        welcome3.animationSpeed = 0.7
        welcome3.backgroundBehavior = .pauseAndRestore
        welcome3.play()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


            labelWelcome3.alpha = 0.0
            labelWelcome3.text = "fridgify is here to help you organise your food, make you enjoy cooking and improve quality of your nutrition"
            labelWelcome3.fadeIn()
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
            


    }
    
    @objc func nextTapped(){
//        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
//        loginVC.modalPresentationStyle = .fullScreen
//        loginVC.modalTransitionStyle = .crossDissolve
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        //navigationController?.popViewController(animated: true)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNC = storyboard.instantiateViewController(withIdentifier: K.loginNC)
        loginNC.modalPresentationStyle = .fullScreen
        self.present(loginNC, animated: true, completion: nil)
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window?.rootViewController = loginVC
        //UIApplication.shared.windows.first?.rootViewController = loginVC
        //self.present(loginNC, animated: true, completion: nil)
        
    }
    
    
}
