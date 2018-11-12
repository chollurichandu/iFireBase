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
        if emailField.text == ""{
            self.showAlertWithMessage(message: "Please enter E-mail")
        }else if passwordField.text == ""{
            self.showAlertWithMessage(message: "Please enter Password")
        }else if displayName.text == ""{
            self.showAlertWithMessage(message: "Please enter Display name")
        }
        
        auth!.createUser(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
            guard let user = authResult?.user else { return }
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
    
    @IBAction func logout(_ sender: Any) {
        do{
            try auth!.signOut()
        }catch{
            print("Error logout!!!!!!")
        }
    }
   
    @IBAction func gotoLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension UIViewController {
    func showAlertWithMessage(message:String) {
        let alert  = UIAlertController.init(title: "Bargain builder", message:message , preferredStyle:.alert)
        let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated:true, completion: nil)
    }
    
}
