//
//  PostVC.swift
//  Fridgify
//
//  Created by Murad Bayramli on 16.02.22.
//

import Foundation
import UIKit
import SCLAlertView
import Alamofire

class PostVC: UIViewController {
    
    
    @IBOutlet weak var postNameTextField: UITextField!
    @IBOutlet weak var postDescriptionTextView: UITextView!
    @IBOutlet weak var addPostButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackground")
        
        addPostButton.layer.cornerRadius = 20
        
        postNameTextField.layer.borderWidth = 1
        postNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        postDescriptionTextView.layer.borderWidth = 1
        postDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    @IBAction func addPostButtonPressed(_ sender: Any) {
        if postNameTextField.text! == "" {
            SCLAlertView().showError("Error", subTitle: "Please enter a name for your Post!")
        }
        
        else {
            var postDescription = ""
            if (postDescriptionTextView.text! != ""){
                postDescription = postDescriptionTextView.text!
            }
            let params : [String:String] = [
                "token":UserDefaults.standard.string(forKey: "token")!,
                "postHeader":postNameTextField.text!,
                "postDescription":postDescription
            ]
            
            AF.request("\(K.apiBaseURL)/auth/api/v1/posts/new", method: .post, parameters: params).responseJSON { response in
                
                print(response)
                
                switch response.result {
                    
                case .success(_):
                    
                        let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                    if let jsonTopLevel = json as? [String: Any] {
                        print(jsonTopLevel["status"]!)
                        let res = jsonTopLevel["status"]!
                        
                        let statusString = "\(res)"
                        
                        if (statusString.toBool()!){
                            
                            
                            SCLAlertView().showSuccess("Success", subTitle: "Your Post has been successfully created!")
                            
                            
                        } else {
                            
                            
                            //let error = jsonTopLevel["error"]!
                            SCLAlertView().showError("Error", subTitle: "Some error has been occured")
                        }

                    }
                    break;
                case .failure(let err):
                    print(err.localizedDescription)
                    SCLAlertView().showError("Error", subTitle: err.localizedDescription)
                
                }
                
            }
            
        }
        postNameTextField.text = ""
        postDescriptionTextView.text = ""
    }
    
    
    
}
