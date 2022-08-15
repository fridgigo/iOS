//
//  MyFridgeVC.swift
//  Fridgify
//
//  Created by Murad Bayramli on 16.02.22.
//

import Foundation
import UIKit


class FridgeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackground")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}
