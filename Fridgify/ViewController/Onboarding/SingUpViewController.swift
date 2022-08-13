//
//  SingUpViewController.swift
//  Fridgify
//
//  Created by Murad Bayramli on 05.02.22.
//

import Foundation
import UIKit
import SCLAlertView
import Alamofire
import MaterialComponents
import Lottie
import TextFieldEffects

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var fullNameTextField: HoshiTextField!
    @IBOutlet weak var usernameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var repeatPasswordTextField: HoshiTextField!
    
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var enterConfirmationButton: UIButton!
    
    @IBOutlet weak var welcomeLottie: AnimationView!
    
    
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("SIGN UP", comment: "")
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationItem.backBarButtonItem?.tintColor = .black
        
        configureSignupButton()
        configureTextFields()
        
        enterConfirmationButton.setTitle(NSLocalizedString("Enter confirmation code", comment: ""), for: .normal)
        
        enterConfirmationButton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        enterConfirmationButton.titleLabel?.layer.shadowRadius = 1.5
        enterConfirmationButton.titleLabel?.layer.shadowOpacity = 0.5
        enterConfirmationButton.titleLabel?.layer.shadowOffset = CGSize(width: 0.5, height: 0.5
        )
        enterConfirmationButton.titleLabel?.layer.masksToBounds = false
        
        
//        configureButton(button: appleButton)
//        configureButton(button: googleButton)
//        configureButton(button: facebookButton)
        
        welcomeLottie.contentMode = .scaleAspectFit
        welcomeLottie.animationSpeed = 0.5
        welcomeLottie.loopMode = .playOnce
        welcomeLottie.play()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {

        
        if (fullNameTextField.text! == "" || usernameTextField.text! == "" || passwordTextField.text! == "" || repeatPasswordTextField.text! == ""){
            SCLAlertView().showError("Error", subTitle: "Please, enter all data")
        }
        
        else if passwordTextField.text! != repeatPasswordTextField.text! {
            SCLAlertView().showError("Error", subTitle: "Passwords are not the same!")
        }
        else {
            
            let params : [String:String] = [
                "fullname":fullNameTextField.text!,
                "email":usernameTextField.text!,
                "password":passwordTextField.text!,
                "repeat_password":repeatPasswordTextField.text!
            ]
            
            AF.request("\(K.apiBaseURL)/api/v1/users/register", method: .post, parameters: params).responseJSON { response in
                
                print(response)
                
                switch response.result {
                    
                case .success(_):
                    
                        let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                    if let jsonTopLevel = json as? [String: Any] {
                        print(jsonTopLevel["status"]!)
                        let res = jsonTopLevel["status"]!
                        
                        let statusString = "\(res)"
                        
                        if (statusString.toBool()!){
                            print("LOGIN SUCCESSFUL")
                            UserDefaults.standard.set(self.usernameTextField.text!, forKey: "username")
                            let appearance = SCLAlertView.SCLAppearance(
                                                            showCloseButton: false)
                                                        
                            let alert = SCLAlertView(appearance: appearance)
                            
                            let textField = alert.addTextField("Enter your confirmation code")
                            
                            
//                            alert.addButton("Done", backgroundColor: UIColor(named: "fridgiBase"), textColor: .white, showTimeout: .none, target: self, selector: #selector(self.goToLoginPage))
                            alert.addButton("Done", backgroundColor: UIColor(named: "fridgiBase"), textColor: .white, showTimeout: .none, action: {
                                if let txt = textField.text{
                                    self.sendOTP(otp: txt)
                                }
                            })
                            alert.showSuccess("Success", subTitle: "Confirmation E-Mail sent! Please check your inbox!")
                        } else {
                            print("LOGIN ERROR1")
                            SCLAlertView().showError("Error", subTitle: "\(jsonTopLevel["message"]!)")
                        }

                    }
                    break;
                case .failure(let err):
                    print(err.localizedDescription)
                
                }
 
            }
            
        }
        
        
        
//        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) {authResult, error in
//            if let e = error {
//                // SHOW USER CREATE ERROR ALERT
//                SCLAlertView().showError("Error", subTitle: e.localizedDescription)
//            }
//            else {
//                Auth.auth().currentUser!.sendEmailVerification(completion: {error in
//                    //SHOW ERROR IF SENDING VERIFICATION EMAIL FAILS
//                    if let e = error {
//                        SCLAlertView().showError("Error", subTitle: e.localizedDescription)
//                    } else {
//                        let appearance = SCLAlertView.SCLAppearance(
//                                showCloseButton: false
//                            )
//                        let alert = SCLAlertView(appearance: appearance)
//
//                        alert.addButton("Done", backgroundColor: UIColor(red: 34/255, green: 181/255, blue: 115/255, alpha: 1.0), textColor: .white, showTimeout: .none, target: self, selector: #selector(self.goToLoginPage))
//                        alert.showSuccess("Success", subTitle: "Your account has been created! Please verify your e-mail before entering your account!")
//
//                    }
//                })
//            }
//        }
            
    }
    
    @IBAction func enterConfirmationPressed(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, showCircularIcon: true, buttonCornerRadius: 8, hideWhenBackgroundViewIsTapped: true)
        
        let alert = SCLAlertView(appearance: appearance)
        let alertIcon = UIImage(named: "mail-icon")

        let emailField = alert.addTextField("Enter your E-Mail")
        let confNumber = alert.addTextField("Enter your confirmation number")
        emailField.textContentType = .emailAddress
        emailField.layer.borderColor = UIColor(named: "fridgiBase")?.cgColor
        confNumber.layer.borderColor = UIColor(named: "fridgiBase")?.cgColor
        
        alert.addButton("Done", backgroundColor: UIColor(named: "fridgiBase"), textColor: .white, showTimeout: .none, action: {
            if let email = emailField.text, let conf = confNumber.text{
                if emailField.text != "" || confNumber.text != "" {

                    self.resendOTP(email: email, otp: conf)
                    
                } else {
                    SCLAlertView().showError("Error", subTitle: "Email or confirmation number cannot be empty")
                }
                
            } else {
                SCLAlertView().showError("Error", subTitle: "Email or confirmation number not valid")
            }
        })
        
        alert.addButton("Close", backgroundColor: .black, textColor: .white, showTimeout: .none, action: {})
        
        //alert.showSuccess("E-Mail Confirmation", subTitle: "", timeout: .none, circleIconImage: alertIcon)
        alert.showCustom("E-Mail Confirmation", subTitle: "", color: UIColor(named: "fridgiBase") ?? UIColor.green, icon: alertIcon ?? UIImage())
        
    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: K.loginVC)
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @objc func goToLoginPage(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "presentLoginPage"), object: nil)
        navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    func sendOTP(otp: String){
        let params : [String:String] = [
            "email":UserDefaults.standard.string(forKey: "username")!,
            "confirmationNumber":otp
        ]
        
        AF.request("\(K.apiBaseURL)/api/v1/users/confirm-user", method: .put, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(_):
                
                let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                if let jsonTopLevel = json as? [String:Any] {
                    let res = jsonTopLevel["status"]!
                    
                    let statusString = "\(res)"
                    
                    if (statusString.toBool()!){
                        let appearance = SCLAlertView.SCLAppearance(
                                                        showCloseButton: false)
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton("Done", backgroundColor: UIColor(named: "fridgiBase"), textColor: .white, showTimeout: .none, target: self, selector: #selector(self.goToLoginPage))
                        
                        alert.showSuccess("Success", subTitle: "Your account has been confirmed! Now you can log in!")
                    } else {
                        SCLAlertView().showError("Error", subTitle: "\(jsonTopLevel["message"]!)")
                    }
                }
                break;
            case .failure(let err):
                print(err.localizedDescription)
                SCLAlertView().showError("Error", subTitle: "\(err.localizedDescription)")
            }
            
        }
    }
    
    
    func resendOTP(email: String, otp: String){
        
        
        
        let params : [String:String] = [
            "email":email,
            "confirmationNumber":otp
        ]
        
        AF.request("\(K.apiBaseURL)/api/v1/users/confirm-user", method: .put, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(_):
                
                let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                if let jsonTopLevel = json as? [String:Any] {
                    let res = jsonTopLevel["status"]!
                    
                    let statusString = "\(res)"
                    
                    if (statusString.toBool()!){
                        let appearance = SCLAlertView.SCLAppearance(
                                                        showCloseButton: false)
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton("Done", backgroundColor: UIColor(named: "fridgiBase"), textColor: .white, showTimeout: .none, target: self, selector: #selector(self.goToLoginPage))
                        
                        alert.showSuccess("Success", subTitle: "Your account has been confirmed! Now you can log in!")
                    } else {
                        SCLAlertView().showError("Error", subTitle: "\(jsonTopLevel["message"]!)")
                    }
                }
                break;
            case .failure(let err):
                print(err.localizedDescription)
                SCLAlertView().showError("Error", subTitle: "\(err.localizedDescription)")
            }
            
        }
    }
    
    
    func configureSignupButton(){
        signupButton.layer.cornerRadius = 20
        signupButton.layer.masksToBounds = false
        signupButton.addShadow(shadowRadius: 7, shadowOpacity: 0.25)
        signupButton.setTitle(NSLocalizedString("SIGN UP", comment: ""), for: .normal)
        
    }
    
    func configureButton(button: UIButton){
        button.layer.cornerRadius = button.frame.width/2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.separator.cgColor
    }
    
    func configureTextFields(){
        usernameTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
        
        fullNameTextField.placeholder = NSLocalizedString("Full Name", comment: "")
        usernameTextField.placeholder = NSLocalizedString("Email", comment: "")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        repeatPasswordTextField.placeholder = NSLocalizedString("Repeat Password", comment: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.fullNameTextField:
            self.usernameTextField.becomeFirstResponder()
        case self.usernameTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.repeatPasswordTextField.becomeFirstResponder()
        default:
            self.view.endEditing(true)
        }
        
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}





