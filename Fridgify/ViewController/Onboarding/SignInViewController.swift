//
//  SignInViewController.swift
//  Fridgify
//
//  Created by Murad Bayramli on 05.02.22.
//

import Foundation
import UIKit
import Lottie
//import Firebase
//importb grpc
import SCLAlertView
import Alamofire
import TextFieldEffects

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    
    var showEmailVerificationAlert = false
    
    
    @IBOutlet weak var signInLottie: AnimationView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loadingLottie: AnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("SIGN IN", comment: "")
        //navigationController?.navigationBar.tintColor = UIColor(named: "mainColorPalette")
        
        configureLottie(lottie: loadingLottie)
        configureLottie(lottie: signInLottie)
        
        loadingLottie.isHidden = true
        
//        if (showEmailVerificationAlert){
//            SCLAlertView().showInfo("Info", subTitle: "Please verify your E-Mail Address to continue!")
//            showEmailVerificationAlert = false
//        }
        
        configureLoginButton()
        configureUsernamePasswordFields()
        forgotPasswordButton.setTitle(NSLocalizedString("Forgot Password?", comment: ""), for: .normal)
        
        
        
        forgotPasswordButton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        forgotPasswordButton.titleLabel?.layer.shadowRadius = 1.5
        forgotPasswordButton.titleLabel?.layer.shadowOpacity = 0.5
        forgotPasswordButton.titleLabel?.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        forgotPasswordButton.titleLabel?.layer.masksToBounds = false
        
//        userIcon.image = UIImage(systemName: "person.fill")
//        passwordIcon.image = UIImage(systemName: "key.fill")
        
        
        
        signInLottie.play()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureLottie(lottie: AnimationView){
        lottie.contentMode = .scaleAspectFit
        lottie.loopMode = .loop
        lottie.animationSpeed = 1.0
    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if (usernameTextField.text! == "" || passwordTextField.text! == ""){
            SCLAlertView().showError("Error", subTitle: "Please, enter a valid e-mail/password")
        } else {
            self.loadingLottie.isHidden = false
            self.loadingLottie.play()
            
            let params : [String:String] = [
                "email":usernameTextField.text!,
                "password":passwordTextField.text!
            ]
            
            AF.request("\(K.apiBaseURL)/api/v1/users/authenticate", method: .post, parameters: params).responseJSON { response in
                
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
                            self.loadingLottie.isHidden = true
                            UserDefaults.standard.set(jsonTopLevel["token"]!, forKey: "token")
                            UserDefaults.standard.set(self.usernameTextField.text!, forKey: "username")
                            self.navigationController?.popToRootViewController(animated: true)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: K.notify_ShowMainNC), object: nil)
                        } else {
                            print("LOGIN ERROR")
                            self.loadingLottie.isHidden = true
                            let error = jsonTopLevel["error"]!
                            SCLAlertView().showError("Error", subTitle: "\(error)")
                        }

                    }
                    break;
                case .failure(let err):   #warning ("Test in the future what happens if there is no response from API")
                    print(err.localizedDescription)
                    SCLAlertView().showError("Error", subTitle: err.localizedDescription)
                
                }
                
            }
            
            
//            Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { authResult, error in
//
//                if let e = error {
//                    self.loadingLottie.stop()
//                    self.loadingLottie.isHidden = true
//                    SCLAlertView().showError("Error", subTitle: e.localizedDescription)
//                } else {
//                    if (Auth.auth().currentUser != nil && !Auth.auth().currentUser!.isEmailVerified){
//                        self.emailNotVerifiedAlert()
//
//                    } else {
//                        self.performSegue(withIdentifier: "LoginToMain", sender: self)
//                    }
//                    self.loadingLottie.stop()
//                    self.loadingLottie.isHidden = true
//                }
//
//            }
        }
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {

        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, buttonCornerRadius: 8, hideWhenBackgroundViewIsTapped: true)
        
        let firstAlert = SCLAlertView(appearance: appearance)
        
        firstAlert.addButton("Request Password", backgroundColor: UIColor(named: "fridgiBase") ?? .blue, textColor: .white, showTimeout: .none, action: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, buttonCornerRadius: 8)
            let passRequestAlert = SCLAlertView(appearance: appearance)
            
            let passReqTextField = passRequestAlert.addTextField("Enter your E-Mail")
            passReqTextField.textContentType = .emailAddress
            passRequestAlert.addButton("Done", textColor: .white, showTimeout: .none, action: {
                if let email = passReqTextField.text {
                    if passReqTextField.text != "" {
                        self.requestPassword(email: email)
                    } else {
                        SCLAlertView().showError("Error", subTitle: "E-Mail cannot be empty")
                        
                    }
                    
                } else {
                    SCLAlertView().showError("Error", subTitle: "Something went wrong")
                }
                
            })
            
            passRequestAlert.addButton("Close", backgroundColor: .black, textColor: .white, showTimeout: .none, action: {})
            
            passRequestAlert.showCustom("Request Password Reset", subTitle: "Here you can request a password reset. You will get a confirmation number on your E-Mail for password reset.", color: UIColor(named: "fridgiBase") ?? .blue, icon: UIImage(named: "eyes-icon") ?? UIImage())
            
        })
        
        firstAlert.addButton("Close", backgroundColor: .black, textColor: .white, showTimeout: .none, action: {})
        
        
        firstAlert.showCustom("Forgot Password", subTitle: "You can request a new password and change it via confirmation number which will be sent to your E-Mail", color: UIColor(named: "fridgiBase") ?? .blue, icon: UIImage(named: "eyes-icon") ?? UIImage())
        
    }
    
    
    func changePassword(email: String, password: String, repeat_password: String, confirmationNumber: String){
        
        let params : [String:String] = [
            "email":email,
            "password":password,
            "repeat_password":repeat_password,
            "confirmationNumber":confirmationNumber
        ]
        
        AF.request("\(K.apiBaseURL)/api/v1/users/change-password", method: .put, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(_):
                
                let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                if let jsonTopLevel = json as? [String:Any] {
                    let res = jsonTopLevel["status"]!
                    
                    let statusString = "\(res)"
                    
                    if (statusString.toBool()!){
                        SCLAlertView().showSuccess("Success 🎉", subTitle: "Congratulations! Your password was changed successfully!")
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
    
    
    func requestPassword(email: String){
        let params : [String:String] = [
            "email":email
        ]
        AF.request("\(K.apiBaseURL)/api/v1/users/request-password", method: .put, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(_):
                
                let json = try! JSONSerialization.jsonObject(with: response.data!, options: .topLevelDictionaryAssumed)
                if let jsonTopLevel = json as? [String:Any] {
                    let res = jsonTopLevel["status"]!
                    
                    let statusString = "\(res)"
                    
                    if (statusString.toBool()!){

                            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, buttonCornerRadius: 8)
                            let changePassAlert = SCLAlertView(appearance: appearance)
                            
                            let passwordField = changePassAlert.addTextField("Enter your new password")
                            let repeatPasswordField = changePassAlert.addTextField("Repeat your new password")
                            let confirmationNumberField = changePassAlert.addTextField("Enter your confirmation number")
                            
                            passwordField.textContentType = .newPassword
                            repeatPasswordField.textContentType = .newPassword
                            
                            passwordField.isSecureTextEntry = true
                            repeatPasswordField.isSecureTextEntry = true
                             
                            changePassAlert.addButton("Done", textColor: .white, showTimeout: .none, action: {
                                if let password = passwordField.text, let repeatPassword = repeatPasswordField.text, let confirmationNumber = confirmationNumberField.text {
                                    if passwordField.text != "" && repeatPasswordField.text != "" && confirmationNumberField.text != "" {
                                        self.changePassword(email: email, password: password, repeat_password: repeatPassword, confirmationNumber: confirmationNumber)
                                    } else {
                                        SCLAlertView().showError("Error", subTitle: "Fields cannot be empty")
                                    }
                                    
                                } else {
                                    SCLAlertView().showError("Error", subTitle: "Something went wrong")
                                }
                                
                            })
                            
                            changePassAlert.addButton("Close", backgroundColor: .black, textColor: .white, showTimeout: .none, action: {})
                            changePassAlert.showCustom("Success 🎉", subTitle: "Your password reset request was successful! Please check your E-Mail for confirmation number!", color: UIColor(named: "fridgiBase") ?? .blue, icon: UIImage(named: "eyes-icon") ?? UIImage())

                        
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
    
    
    
    func configureUsernamePasswordFields(){
        usernameTextField.keyboardType = .emailAddress
        usernameTextField.autocorrectionType = .no
        
        
        
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        
        //usernameTextField.text = "muratti_az@icloud.com"
        //passwordTextField.text = "jeyhun"
        
        usernameTextField.placeholder = NSLocalizedString("Email", comment: "")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
    }
    
    func configureLoginButton(){
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = false
        loginButton.addShadow(shadowRadius: 7, shadowOpacity: 0.25)
        loginButton.setTitle(NSLocalizedString("LOGIN", comment: ""), for: .normal)
    }
    
    func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            
        }))
        return alert
    }
    
    func createAlertWithAction(title: String, message: String, actionTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            
        }))
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: {_ in
            
        }))
        return alert
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.usernameTextField:
            self.passwordTextField.becomeFirstResponder()
        default:
            self.view.endEditing(true)
        }

        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

