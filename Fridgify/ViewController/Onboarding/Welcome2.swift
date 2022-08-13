//
//  Welcome2.swift
//  Fridgify
//
//  Created by Murad Bayramli on 05.02.22.
//

import Foundation
import UIKit
import Lottie


class Welcome2: UIViewController {
    
    @IBOutlet weak var welcome2: AnimationView!
    @IBOutlet weak var labelWelcome2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcome2.contentMode = .scaleAspectFit
        welcome2.loopMode = .loop
        welcome2.animationSpeed = 0.7
        welcome2.backgroundBehavior = .pauseAndRestore
        welcome2.play()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


            labelWelcome2.alpha = 0.0
            labelWelcome2.text = "Don't know what to cook or tired of same food every day?"
            labelWelcome2.fadeIn()
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
            


    }
    
    @objc func nextTapped(){
        let welcome3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: K.welcome3)
        navigationController?.pushViewController(welcome3, animated: true)
        labelWelcome2.alpha = 0.0
    }
    
    
}

