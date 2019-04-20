//
//  ChatViewController.swift
//  iFireBase
//
//  Created by Rahul on 05/11/18.
//  Copyright © 2018 arka. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ChatViewController: UIViewController {
    
    //MARK:- Outlet fields
    @IBOutlet weak var infoLab: UILabel!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var messageText: UITextField!
    
    //MARK:- Private fields
    fileprivate var ref: DatabaseReference!
    fileprivate var messages: [DataSnapshot]! = []
    fileprivate var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?
    fileprivate var uid:String = ""
    fileprivate var width:CGFloat = 0
   
    //MARK:- Param fields
    var chatWith:String = "" //user id who we are chatting with
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
        self.infoLab.text = ""
        uid = Auth.auth().currentUser?.uid ?? ""
        configureDatabase()
    }
    
    
    func configureDatabase() {
        //MARK:- Create Database refference
        //To create url of these two user chat call "getID" method
        ref = Database.database().reference().child("messages/\(getId(s1: (Auth.auth().currentUser?.uid)!, s2: chatWith))")
        print(getId(s1: (Auth.auth().currentUser?.uid)!, s2: chatWith))
        // Listen for new messages in the Firebase database
        
        _refHandle = ref.observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.chatTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
        
    }
    //MARK:- get both user message id
    fileprivate func getId( s1:String, s2:String) -> String{
        //if user a message with b or b message a we have to create
        //one url which share same DB url
        if (s1 > s2) {
            return "\(s1)_\(s2)"
        } else {
            return "\(s2)_\(s1)"
        }
    }
    fileprivate func downloadProfilePic(imageView:UIImageView, image:String) {
        if Auth.auth().currentUser != nil{
            //Create storage object
            let storage = Storage.storage()
            
            //create file referece which we have to download
            let storageRef = storage.reference(withPath:"chat/\(image)")//.child("2465785.jpg") //forURL:"gs://developers-point.appspot.com/2465785.jpg"
            // Download image
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    let imagex = UIImage(data: data!)
                    imageView.image = imagex
                }
            }
        }else{
            print("You should be logged in")
            
        }
    }
    @IBAction func send(_ sender: Any) {
        sendMessage(message: messageText.text!, type: "text")
    }
    fileprivate func sendMessage(message:String, type:String ) {
        ref.childByAutoId().setValue(["by":"ios", "message":message ,"user": uid,"at":  NSDate().timeIntervalSince1970,"type" : type])
        self.view.endEditing(true) //This will hide the keyboard
        messageText.text = ""
    }
    
    
    @IBAction func uploadFile(_ sender: Any) {
        photoLibrary()
    }
    
}
extension ChatViewController:UITableViewDataSource,UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //
    //        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
    //        var message:[String:Any]?
    //        if let tmp = messageSnapshot.value as? [String:Any] {
    //            message = tmp
    //        }
    //        let txt:String = message?["message"] as? String ?? ""
    //
    //        let cgsiz = CGSize(width: self.view.frame.width , height:1000)
    //        let att = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
    //        let estFram = NSString(string: txt).boundingRect(with: cgsiz, options: .usesLineFragmentOrigin, attributes: att, context: nil)
    //        let height = estFram.height + 40
    //
    //        width = estFram.width
    //        if(width > self.view.frame.width){
    //            width = self.view.frame.width
    //        }
    //        return height
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        var message:[String:Any]?
        if let tmp = messageSnapshot.value as? [String:Any] {
            message = tmp
        }
        var height:CGFloat = 0
        if((message?["type"] as! String) == "image"){
            height = 76
        }else{
            let txt:String = message?["message"] as? String ?? ""
            
            let cgsiz = CGSize(width: (self.view.frame.width ), height:1000)
            let att = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            let estFram = NSString(string: txt).boundingRect(with: cgsiz, options: .usesLineFragmentOrigin, attributes: att, context: nil)
            height = estFram.height + 45
            
            width = estFram.width
        }
        //        if(width > (self.view.frame.width )){
        //            width = (self.view.frame.width )
        //        }
        
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
        let type:String = message?["type"] as? String ?? ""
        
        let at = message?["at"] as? Double ?? 0
        
        let date = Date(timeIntervalSince1970: at)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm"//"yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        if(type == "image"){
            if(sender == uid){
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightImageTableViewCell", for: indexPath) as! RightImageTableViewCell
                
                let name = message?["message"] as? String ?? ""
                
                downloadProfilePic(imageView: cell.imageV, image: name)
                //            cell.wrapperView.frame.size.width = width
                //            cell.message.frame.size.width = width
                //            cell.message.text = name
                //            cell.time.text = strDate
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftImageTableViewCell", for: indexPath) as! LeftImageTableViewCell
                
                let name = message?["message"] as? String ?? ""
                
                downloadProfilePic(imageView: cell.imageV, image: name)
                //            cell.wrapperView.frame.size.width = width
                //            cell.message.frame.size.width = width
                //            cell.message.text = name
                //            cell.time.text = strDate
                
                return cell
            }
        }else{
            if(sender == uid){
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatTableViewCell", for: indexPath) as! RightChatTableViewCell
                
                let name = message?["message"] as? String ?? ""
                
                
                cell.wrapperView.frame.size.width = width
                cell.message.frame.size.width = width
                cell.message.text = name
                cell.time.text = strDate
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
                
                let name = message?["message"] as? String ?? ""
                
                cell.wrapperView.frame.size.width = width
                cell.message.frame.size.width = width
                cell.message.text = name
                cell.time.text = strDate
                return cell
            }
        }
    }
    
    
}

extension ChatViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if Auth.auth().currentUser != nil {
            if let imageUrl:URL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                // Get a non-default Storage bucket
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let fileName = String(NSDate().timeIntervalSince1970)
                // Create a reference to the file you want to upload
                let riversRef = storageRef.child("chat/\(fileName).jpg")
                
                self.infoLab.text = "File uploading"
                // Upload the file to the path "images/rivers.jpg"
                let uploadTask = riversRef.putFile(from: imageUrl , metadata: nil) { (metadata, error) in
                    self.infoLab.text = ""
                    print(error)
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    self.sendMessage(message: "\(fileName).jpg" , type: "image")
                    
                }
                uploadTask.observe(.progress) { (snapshot) in
                    print(snapshot.progress) // NSProgress object
                }
            }
        }else{
            print("You should be logged in")
        }
    }
}
