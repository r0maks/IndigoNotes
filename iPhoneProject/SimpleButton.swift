//
//  SimpleButton.swift
//  iPhoneProject
//
//  Created by Román Maksimov on 4/20/17.
//  Copyright © 2017 Román Maksimov. All rights reserved.
//

import UIKit

class SimpleButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required public init?(coder aDecoder: NSCoder) {
        
        // colors and fonts
        super.init(coder: aDecoder);
        self.backgroundColor = UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1.0);
        
    }

}
