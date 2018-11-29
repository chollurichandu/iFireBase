//
//  EditProfileViewController.swift
//  iFireBase
//
//  Created by Rahul on 14/11/18.
//  Copyright © 2018 arka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class EditProfileViewController: UIViewController {
    @IBOutlet weak var profieImage: UIImageView!
    
    fileprivate func downloadProfilePic() {
        if let user = Auth.auth().currentUser{
            let storage = Storage.storage()
            
            let storageRef = storage.reference(withPath:"profile/user_\(user.uid).jpg")//.child("2465785.jpg") //forURL:"gs://developers-point.appspot.com/2465785.jpg"
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    let imagex = UIImage(data: data!)
                    self.profieImage.image = imagex
                }
            }
        }else{
            print("You should be logged in")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadProfilePic()
    }
    
    
    @IBAction func editImage(_ sender: Any) {
        photoLibrary()
    }
    
    
}
extension EditProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let user = Auth.auth().currentUser{
            profieImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            
            if let imageUrl:URL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                // Get a non-default Storage bucket
                let storage = Storage.storage()
                let storageRef = storage.reference()
                
                
                //            var data = Data()
                //            data =  image.jpegData(compressionQuality: 0.8)!
                
                
                
                // Create a reference to the file you want to upload
                let riversRef = storageRef.child("profile/user_\(user.uid).jpg")
                
                // Upload the file to the path "images/rivers.jpg"
                let uploadTask = riversRef.putFile(from: imageUrl , metadata: nil) { (metadata, error) in
                    print(error)
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    self.downloadProfilePic()
                    // Metadata contains file metadata such as size, content-type.
                    let size = metadata.size
                    // You can also access to download URL after upload.
                    riversRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                    }
                }
            }
        }else{
            print("You should be logged in")
        }
    }
}
