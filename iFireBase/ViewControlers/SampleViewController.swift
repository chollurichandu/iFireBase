//
//  SampleViewController.swift
//  iFireBase
//
//  Created by Rahul on 19/11/18.
//  Copyright © 2018 arka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class SampleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    fileprivate var ref: DatabaseReference!
    fileprivate var messages: [DataSnapshot]! = []
    fileprivate var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 configureDatabase()
        
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("bookings").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            let id = snapshot.childSnapshot(forPath: "customer_id").value as! String
            strongSelf.ref.child("users/\(id)").observe(DataEventType.value, with: { (snap) in
                strongSelf.messages.append(snap)
                strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
            })
//            strongSelf.messages.append(snapshot)
//            strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
}
extension SampleViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleTableViewCell", for: indexPath) as! SampleTableViewCell
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:Any] else { return cell }
        print(messageSnapshot.key)
        let name = message["email"] as? String ?? ""
        cell.label1.text = name
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        chatViewController.chatWith = messageSnapshot.key
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
}
