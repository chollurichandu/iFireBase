//
//  LoginViewController.swift
//  iFireBase
//
//  Created by Rahul on 12/11/18.
//  Copyright © 2018 arka. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    var auth:Auth!
    fileprivate var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        emailField.keyboardType = .emailAddress
        passwordField.isSecureTextEntry = true
        ref = Database.database().reference()
    }
    @IBAction func signin(_ sender: Any) {
        if emailField.text == ""{
            self.showAlertWithMessage(message: "Please enter E-mail")
        }else if passwordField.text == ""{
            self.showAlertWithMessage(message: "Please enter Password")
        }
        
        auth.signIn(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in            
            guard let user = authResult?.user else { return }
            
            print(user)
           
            let rootVC:UsersListViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersListViewController") as! UsersListViewController
            let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
            nvc.viewControllers = [rootVC]
            UIApplication.shared.keyWindow?.rootViewController = nvc
        }
    }
    @IBAction func gotoLogin(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: self)
    }
}
