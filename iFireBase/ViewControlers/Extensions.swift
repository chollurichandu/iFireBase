//
//  Extensions.swift
//  iFireBase
//
//  Created by Rahul on 20/04/19.
//  Copyright © 2019 arka. All rights reserved.
//

import UIKit
extension UIViewController {
    func showAlertWithMessage(message:String) {
        let alert  = UIAlertController.init(title: "iFireBase", message:message , preferredStyle:.alert)
        let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated:true, completion: nil)
    }
}
