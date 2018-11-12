//
//  SSImage.swift
//  buildingcodes
//
//  Created by Rahul on 16/10/18.
//  Copyright © 2018 manan. All rights reserved.
//

import UIKit


@IBDesignable
class SSImage: UIImageView {
    
    @IBInspectable var radius:Bool = false {
        didSet{
            updateRadius()
        }
    }
    //    @IBInspectable var ShadowX:Int = 1 {
    //        didSet{
    //            updateRadius()
    //        }
    //    }
    //    @IBInspectable var ShadowY:Int = 1 {
    //        didSet{
    //            updateRadius()
    //        }
    //    }
    
    
    @IBInspectable var radiusAmt:CGFloat = 0 {
        didSet{
            updateRadius()
        }
    }
    
    
    override class var layerClass: Swift.AnyClass{
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateRadius(){
        if(radius){
            self.layer.cornerRadius = radiusAmt;
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            self.layer.masksToBounds = true;
        }
    }
    
}

