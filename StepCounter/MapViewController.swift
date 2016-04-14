//
//  MapViewController.swift
//  StepCounter
//
//  Created by Daniel Margulis on 3/21/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapBackgroundView: UIView!
    
    @IBOutlet weak var controlPanalView: UIView!
    
    
    var maps: [mapObject]!
    var curLocation: [Int]!
    
    var mapBackgroundOriginalCenter: CGPoint!
    
    var farthestXPos: CGFloat!
    var farthestXNeg: CGFloat!
    var farthestYPos: CGFloat!
    var farthestYNeg: CGFloat!
    
    var totalTransX: CGFloat!
    var totalTransY: CGFloat!
    
    var mapBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curLocation[0] = curLocation[0] / 2
        curLocation[1] = curLocation[1] / 2
        
        farthestXPos = farthestXPos / 2
        farthestYPos = farthestYPos / 2
        farthestXNeg = farthestXNeg / 2
        farthestYNeg = farthestYNeg / 2
        
        if(farthestXPos < 5){
            farthestXPos = 5
        }
        if(farthestXNeg > -5){
            farthestXNeg = -5
        }
        if(farthestYPos < 5){
            farthestYPos = 5
        }
        if(farthestYNeg > -5){
            farthestYNeg = -5
        }

        
        for view in mapBackgroundView.subviews{
            view.removeFromSuperview()
        }

        mapBackgroundView.setNeedsLayout()
        mapBackgroundView.layoutIfNeeded()
        
        let widthByCellCount = CGFloat(10)
        let heightByCellCount = CGFloat(10)
        
        
        mapBackgroundOriginalCenter = mapBackgroundView.center
        let mapWidth = mapBackgroundView.frame.size.width
        let mapHeight = mapBackgroundView.frame.size.height

        let mapCenter = mapBackgroundView.center
        let cellWidth = mapWidth / 10
        let cellHeight = mapHeight / 10
        
        mapBackgroundView.removeFromSuperview()
        
        let newMapBackground = UIView()
        newMapBackground.backgroundColor = UIColor.grayColor()
        
        newMapBackground.frame.size.height = heightByCellCount * cellHeight
        newMapBackground.frame.size.width = widthByCellCount * cellWidth

        newMapBackground.center = mapCenter
        
        self.view.addSubview(newMapBackground)
        
        let mapCenterX = newMapBackground.center.x
        let mapCenterY = newMapBackground.center.y
        
        let mapsContainer = UIView()
        self.view.addSubview(mapsContainer)
        mapsContainer.frame = newMapBackground.frame
        self.mapBackgroundOriginalCenter = mapsContainer.center
        
        
        for map in maps{
            
            
            
            let newView = UIView(frame: CGRectMake(0, 0, cellWidth, cellHeight))
            let xLoc = map.centerLocation[0] - curLocation[0]
            let yLoc = map.centerLocation[1] - curLocation[1]
            
            
            
//            newView.center.x = mapCenterX + CGFloat(map.centerLocation[0] - curLocation[0]) / 2.0 * cellWidth
//            newView.center.y = mapCenterY - CGFloat(map.centerLocation[1] - curLocation[1]) / 2.0 * cellHeight
            

            newView.center.x = mapCenterX + CGFloat(map.centerLocation[0]) / 2.0 * cellWidth
            newView.center.y = mapCenterY - CGFloat(map.centerLocation[1]) / 2.0 * cellHeight
            if(map.centerLocation[0]==curLocation[0] * 2 && map.centerLocation[1] == curLocation[1] * 2){
                newView.backgroundColor = UIColor(patternImage: UIImage(named: "playerDown")!)
                
            } else{
                newView.backgroundColor = map.view.backgroundColor
            }
            mapsContainer.addSubview(newView)
            
            var items = false
            for i in map.items{
                if i.found == false{
                    items = true
                    break
                }
            }
            newView.layer.borderWidth = 1
            if items {
                newView.layer.borderColor = UIColor.redColor().CGColor
            } else {
                newView.layer.borderColor = UIColor.blackColor().CGColor
            }
            
        }
        
        
        
        
        let gr = UIPanGestureRecognizer(target: self, action: "onMapPan:")
        let gestureHandler = UIView()
        gestureHandler.frame = newMapBackground.frame
        gestureHandler.center = newMapBackground.center
        self.view.addSubview(gestureHandler)
        gestureHandler.addGestureRecognizer(gr)
        
        
        //mapsContainer.addGestureRecognizer(gr)
        //newMapBackground.center = mapBackgroundOriginalCenter
        
        self.mapBackground = mapsContainer
        self.view.sendSubviewToBack(newMapBackground)
        
        
        farthestXPos = farthestXPos * cellWidth
        farthestYPos = farthestYPos * cellHeight
        farthestXNeg = farthestXNeg * cellWidth
        farthestYNeg = farthestYNeg * cellHeight
        
        totalTransX = CGFloat(0)
        totalTransY = CGFloat(0)

        // Do any additional setup after loading the view.
        controlPanalView.backgroundColor = UIColor.redColor()
        controlPanalView.layer.zPosition = 10
        
        mapsContainer.layer.zPosition = 9
        newMapBackground.layer.zPosition = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ontapBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func onMapPan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(mapBackground)
        
        if sender.state == UIGestureRecognizerState.Began {

            
            
        } else if sender.state == UIGestureRecognizerState.Changed{
            
//           if(totalTransX + translation.x < farthestXPos && totalTransX + translation.x > farthestXNeg){
//                if(totalTransY + translation.y < farthestYPos && totalTransY + translation.y > farthestYNeg){
//                    mapBackground.center = CGPoint(x: mapBackgroundOriginalCenter.x + translation.x, y: mapBackgroundOriginalCenter.y + translation.y)
//                }
//            }
            
            mapBackground.center = CGPoint(x: mapBackgroundOriginalCenter.x + translation.x, y: mapBackgroundOriginalCenter.y + translation.y)
            
            
        }else if sender.state == UIGestureRecognizerState.Ended{
            mapBackgroundOriginalCenter = mapBackground.center
            totalTransX = totalTransX + translation.x
            totalTransY = totalTransY + translation.y
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
