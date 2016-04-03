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
    
    var itemView: UIImageView!
    
    var absolutePosition: [Int]!
    
    let correctionHeight: CGFloat! = 60
    
    init(name: String, description: String, picture: UIImage, xPos: Int, yPos: Int, width: CGFloat, height: CGFloat, mapCenter: CGPoint, positionInMap: [Int]!){
        
        
        //print("making new item")
        //print("center x = \(mapCenter.x)")
        //print("center y = \(mapCenter.y)")
        
        //print("position x = \(positionInMap[0])")
        //print("position y = \(positionInMap[1])")
            
        
        self.name = name
        self.descrip = description
        self.picture = picture
        self.found = false
        self.xPos = xPos
        self.yPos = yPos
        self.absolutePosition = positionInMap
        
        
        
        itemView = UIImageView(frame: CGRectMake(0, 0, width, height))
        itemView.image = picture
        itemView.center.x = mapCenter.x + width * CGFloat(xPos)
        itemView.center.y = mapCenter.y - (height * CGFloat(yPos)) - correctionHeight
        
        itemView.layer.borderWidth = 1
        itemView.layer.borderColor = UIColor.blackColor().CGColor
        
    }
    
}
