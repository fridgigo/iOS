//
//  EditProfileViewController.swift
//  Fridgify
//
//  Created by Murad Bayramli on 15.08.22.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    
    let profileImage: UIImageView = UIImageView()
    @IBOutlet weak var editProfileTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileTableView.delegate = self
        editProfileTableView.dataSource = self
        
        
    }
    

  

}

extension EditProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
