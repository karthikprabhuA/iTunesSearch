//
//  PriceLabel.swift
//  iTunesSearch
//
//  Created by Alagu Karthik Prabhu on 05/02/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

import UIKit

class UIPriceLabel: UILabel {
    
    let systemBlueColor = UIColor(red: CGFloat(0.0), green: CGFloat(122.0 / 255.0), blue: CGFloat(1.0), alpha: CGFloat(1.0))
    var borderWidth = 1
    var borderColor:UIColor?
    var cornerRadius = 5
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        borderColor = systemBlueColor
        self.textColor = systemBlueColor
        self.layer.cornerRadius = CGFloat(self.cornerRadius)
        self.layer.borderWidth = CGFloat(self.borderWidth)
        self.layer.borderColor = borderColor?.cgColor
    }
  
}
