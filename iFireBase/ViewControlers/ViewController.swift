//
//  ViewController.swift
//  iFireBase
//
//  Created by Rahul on 05/11/18.
//  Copyright © 2018 arka. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var auth:Auth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        auth = Auth.auth()
        
        if(auth!.currentUser?.uid != nil || auth!.currentUser?.uid != "" ){
            let userListControler = self.storyboard?.instantiateViewController(withIdentifier: "UsersListViewController") as! UsersListViewController
            self.navigationController?.pushViewController(userListControler, animated: true)
        }
        
        
    }
    @IBAction func signUp(_ sender: Any) {
        auth!.createUser(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
            guard let user = authResult?.user else { return }
            
            print(user)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        auth!.signIn(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
            
            guard let user = authResult?.user else { return }
            
            print(user)
        }
       
    }
    
}

