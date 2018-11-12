//
//  GradientView.swift
//  Currency Converter
//
//  Created by Amit Shukla on 02/01/18.
//  Copyright © 2018 Amit Shukla. All rights reserved.
//

import UIKit

@IBDesignable
class SSView: UIView {
    
    @IBInspectable var GradientFirstColor :UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    @IBInspectable var GradientSecondColor :UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var useShadow:Bool = false {
        didSet{
            if(useShadow){
                dropShadow(scale: false)
            }
        }
    }
    @IBInspectable var shadowColor :UIColor = UIColor.blue {
        didSet{
            if(useShadow){
                dropShadow(scale: false)
            }
        }
    }
    @IBInspectable var shadowRadius:CGFloat = 0 {
        didSet{
            if(useShadow){
                dropShadow(scale: false)
            }
        }
    }
    @IBInspectable var radius:Bool = false {
        didSet{
            updateRadius()
        }
    }
    @IBInspectable var  ShadowX:Int = 1 {
        didSet{
            updateRadius()
        }
    }
    @IBInspectable var  ShadowY:Int = 1 {
        didSet{
            updateRadius()
        }
    }
    
    
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
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [GradientFirstColor.cgColor, GradientSecondColor.cgColor]
        
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: ShadowX, height: ShadowY)
        self.layer.shadowRadius = shadowRadius
        
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
    
    func updateRadius(){
        if(radius){
            self.layer.cornerRadius = radiusAmt;
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            //            self.layer.masksToBounds = true;
        }
    }
    
}
