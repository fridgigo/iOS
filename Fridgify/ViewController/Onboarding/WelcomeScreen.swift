//
//  WelcomeScreen.swift
//  Fridgify
//
//  Created by Murad Bayramli on 05.02.22.
//

import Foundation
import UIKit
import Lottie


class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var welcome1: AnimationView!
    @IBOutlet weak var labelWelcome1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcome1.contentMode = .scaleAspectFit
        welcome1.loopMode = .loop
        welcome1.animationSpeed = 0.9
        welcome1.backgroundBehavior = .pauseAndRestore
        welcome1.play()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


            labelWelcome1.alpha = 0.0
            labelWelcome1.text = "Have you ever been standing in front of the fridge asking yourself what to cook?"
            labelWelcome1.fadeIn()
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
            


    }
    
    @objc func nextTapped(){
        let welcome2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: K.welcome2)
        navigationController?.pushViewController(welcome2, animated: true)
        labelWelcome1.alpha = 0.0
    }
    
    
    
    
}

extension UIView {
    func fadeIn(duration: TimeInterval = 1.5, delay: TimeInterval = 0.2, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
