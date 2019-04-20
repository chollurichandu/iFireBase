//
//  ViewController.swift
//  iFireBase
//
//  Created by Rahul on 05/11/18.
//  Copyright © 2018 arka. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var displayName: UITextField!
    
    fileprivate var ref: DatabaseReference!
    
    var auth:Auth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        
        emailField.attributedPlaceholder =  NSAttributedString(string: "E-mail",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        passwordField.attributedPlaceholder =  NSAttributedString(string: "Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        displayName.attributedPlaceholder =  NSAttributedString(string: "Display Name",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
        
        emailField.keyboardType = .emailAddress
        passwordField.isSecureTextEntry = true
        ref = Database.database().reference()
        
        if(auth!.currentUser?.uid != nil){
            
            
            let rootVC:UsersListViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersListViewController") as! UsersListViewController
            let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
            nvc.viewControllers = [rootVC]
            UIApplication.shared.keyWindow?.rootViewController = nvc
            
            //            let userListControler = self.storyboard?.instantiateViewController(withIdentifier: "UsersListViewController") as! UsersListViewController
            //            self.navigationController?.pushViewController(userListControler, animated: true)
        }
    }
    @IBAction func signUp(_ sender: Any) {
        if displayName.text == ""{
            self.showAlertWithMessage(message: "Please enter Display name")
            return
        }else if emailField.text == ""{
            self.showAlertWithMessage(message: "Please enter E-mail")
            return
        }else if passwordField.text == ""{
            self.showAlertWithMessage(message: "Please enter Password")
            return
        }
        
        auth!.createUser(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
            guard let user = authResult?.user else {
                print(error)
                return
            }
            print(user)
            let userMeta:[String:Any] = [
                "isOnline" : true,
                "email" : self.emailField.text!,
                "profileDisplayName" : self.displayName.text!
            ]
            self.ref.child("users").child(user.uid).setValue(userMeta)
            
            let rootVC:UsersListViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersListViewController") as! UsersListViewController
            let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
            nvc.viewControllers = [rootVC]
            UIApplication.shared.keyWindow?.rootViewController = nvc
            
        }
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
      
    }
    
}
