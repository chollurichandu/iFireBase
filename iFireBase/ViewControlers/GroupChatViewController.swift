//
//  GroupChatViewController.swift
//  iFireBase
//
//  Created by Rahul on 11/11/18.
//  Copyright © 2018 arka. All rights reserved.
//


import UIKit
import FirebaseDatabase
import FirebaseAuth
class GroupChatViewController: UIViewController {
    
    @IBOutlet weak var chatTable: UITableView!
    
    fileprivate var ref: DatabaseReference!
    fileprivate var messages: [DataSnapshot]! = []
    fileprivate var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?
    @IBOutlet weak var messageText: UITextField!
    
    var chatWith:String = ""
    
    var uid:String = ""
    
    var width:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid ?? ""
        configureDatabase()
    }
   
    func configureDatabase() {
        ref = Database.database().reference().child("gchat")
        // Listen for new messages in the Firebase database
        
        _refHandle = ref.observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.chatTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
    
    @IBAction func send(_ sender: Any) {
        ref.childByAutoId().setValue(["by":"ios", "message":messageText.text!,"user": uid])
        self.view.endEditing(true) //This will hide the keyboard
        messageText.text = ""
    }
    
    
    
}
extension GroupChatViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        var message:[String:Any]?
        if let tmp = messageSnapshot.value as? [String:Any] {
            message = tmp
        }
        let txt:String = message?["message"] as? String ?? ""
        
        let cgsiz = CGSize(width: (self.view.frame.width ), height:1000)
        let att = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let estFram = NSString(string: txt).boundingRect(with: cgsiz, options: .usesLineFragmentOrigin, attributes: att, context: nil)
        let height = estFram.height + 25
        
        width = estFram.width
        return height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        var message:[String:Any]?
        if let tmp = messageSnapshot.value as? [String:Any] {
            message = tmp
        }
        let sender:String = message?["user"] as? String ?? ""
        if(sender == uid){
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatTableViewCell", for: indexPath) as! RightChatTableViewCell
            
            let name = message?["message"] as? String ?? ""
            cell.wrapperView.frame.size.width = width
            cell.message.frame.size.width = width
            cell.message.text = name
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            
            let message = message?["message"] as? String ?? ""
            cell.wrapperView.frame.size.width = width
            cell.message.frame.size.width = width
            cell.message.text = message
            
            return cell
        }
    }
    
}

