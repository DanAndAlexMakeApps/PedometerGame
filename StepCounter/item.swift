//
//  item.swift
//  StepCounter
//
//  Created by Daniel Margulis on 2/14/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit

class item: NSObject {

    
    var name: String = ""
    var descrip: String = ""
    var picture: UIImage
    var xPos: Int
    var yPos: Int
    var found: Bool
    
    var itemView: UIView!
    
    init(name: String, description: String, picture: UIImage, xPos: Int, yPos: Int){
        self.name = name
        self.descrip = description
        self.picture = picture
        self.found = false
        self.xPos = xPos
        self.yPos = yPos
    }
    
}
