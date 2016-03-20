//
//  mapView.swift
//  StepCounter
//
//  Created by Daniel Margulis on 3/8/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit

class mapView: UIView {

    var centerLocation: [Int]!
    var items: [item]!
    var color: UIColor!
    
    init(centerLocation: [Int], items: [item], color: UIColor){
        
        self.centerLocation = centerLocation
        self.items = items
        self.color = color
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
