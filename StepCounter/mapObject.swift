//
//  mapObject.swift
//  StepCounter
//
//  Created by Daniel Margulis on 3/9/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit

class mapObject: NSObject {

    var centerLocation: [Int]!
    var items: [item]!
    var color: UIColor!
    var view: UIView!
    
    var cellHeight: CGFloat!
    var cellWidth: CGFloat!
    
    var center: CGPoint!
    
    init(cLoc: [Int], view: UIView, cellWidth: CGFloat, cellHeight: CGFloat, center: CGPoint){
        self.centerLocation = cLoc
        self.items = []
        self.view = view
        self.cellHeight = cellHeight
        self.cellWidth = cellWidth
        self.center = center
        
        
        //create an item creating function
        let distx = Double(centerLocation[0])
        let disty = Double(centerLocation[1])
        
        let dist = distx * distx + disty * disty
        
        
        var odds = dist / (50.0*50.0+50.0*50.0)
        
        if(odds < 0.1){
            odds = 0.1
        } else if(odds > 0.9){
            odds = 0.9
        }
        
        
        for i in 1...10{
            let chance = Double(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
            if(chance < odds){
                
                //customize item properly
                //randomize position
                let newItem = item(name: "", description: "", picture: UIImage(named: "shield")!, xPos: i, yPos: i, width: cellWidth, height: cellHeight, mapCenter: view.center)
                items.append(newItem)
                self.view.addSubview(newItem.itemView)
                
                
                
            } else{
                print("No item")
            }
        }
        
        
    }
    
    
}
