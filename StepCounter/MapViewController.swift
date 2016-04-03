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
    
    var maps: [mapObject]!
    var curLocation: [Int]!
    
    var mapBackgroundOriginalCenter: CGPoint!
    
    var farthestXPos: CGFloat!
    var farthestXNeg: CGFloat!
    var farthestYPos: CGFloat!
    var farthestYNeg: CGFloat!
    
    var mapBackground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        curLocation[0] = curLocation[0] / 2
        curLocation[1] = curLocation[1] / 2
        
        print("curlocation0: \(curLocation[0])")
        print("curlocation1:   \(curLocation[1])")
        
        if(farthestXNeg > -5){
            farthestXNeg = -5
        }
        if(farthestXPos < 5){
            farthestXPos = 5
        }
        if(farthestYNeg > -5){
            farthestYNeg = -5
        }
        if(farthestYPos < 5){
            farthestYPos = 5
        }
        
        print("farthestXNeg \(farthestXNeg)")
        print("farthestYNeg \(farthestYNeg)")
        print("farthestXPos \(farthestXPos)")
        print("farthestYPos \(farthestYPos)")

        for view in mapBackgroundView.subviews{
            view.removeFromSuperview()
        }

        mapBackgroundView.setNeedsLayout()
        mapBackgroundView.layoutIfNeeded()
        
        var widthByCellCount = farthestXPos - farthestXNeg
        var heightByCellCount = farthestYPos - farthestYNeg
        
        
        mapBackgroundOriginalCenter = mapBackgroundView.center
        let mapWidth = mapBackgroundView.frame.size.width
        let mapHeight = mapBackgroundView.frame.size.height
        
        print("mapWidth: \(mapWidth)")
        print("mapHeight: \(mapHeight)")

        let mapCenter = mapBackgroundView.center
        let cellWidth = mapWidth / 10
        let cellHeight = mapHeight / 10
        
        print("mapCenter: \(mapCenter)")
        
        mapBackgroundView.removeFromSuperview()
        
        let newMapBackground = UIView()
        newMapBackground.backgroundColor = UIColor.grayColor()
        
        newMapBackground.frame.size.height = heightByCellCount * cellHeight
        newMapBackground.frame.size.width = widthByCellCount * cellWidth

        newMapBackground.center = mapCenter
        
        self.view.addSubview(newMapBackground)
        
        let mapCenterX = newMapBackground.center.x
        let mapCenterY = newMapBackground.center.y
        
        for map in maps{
            
            
            
            let newView = UIView(frame: CGRectMake(0, 0, cellWidth, cellHeight))
            let xLoc = map.centerLocation[0] - curLocation[0]
            let yLoc = map.centerLocation[1] - curLocation[1]
            
            
            
//            newView.center.x = mapCenterX + CGFloat(map.centerLocation[0] - curLocation[0]) / 2.0 * cellWidth
//            newView.center.y = mapCenterY - CGFloat(map.centerLocation[1] - curLocation[1]) / 2.0 * cellHeight
            

            newView.center.x = mapCenterX + CGFloat(map.centerLocation[0]) / 2.0 * cellWidth
            newView.center.y = mapCenterY - CGFloat(map.centerLocation[1]) / 2.0 * cellHeight
            if(map.centerLocation[0]==curLocation[0] && map.centerLocation[1] == curLocation[1]){
                newView.backgroundColor = UIColor(patternImage: UIImage(named: "playerDown")!)
                
            } else{
                newView.backgroundColor = map.view.backgroundColor
            }
            newMapBackground.addSubview(newView)
            
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
        newMapBackground.addGestureRecognizer(gr)
        //newMapBackground.center = mapBackgroundOriginalCenter
        
        self.mapBackground = newMapBackground
        self.view.sendSubviewToBack(newMapBackground)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ontapBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        print("back")
    }

    
    @IBAction func onMapPan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(mapBackground)
        
        if sender.state == UIGestureRecognizerState.Began {

            
            
        } else if sender.state == UIGestureRecognizerState.Changed{
            
            
            mapBackground.center = CGPoint(x: mapBackgroundOriginalCenter.x + translation.x, y: mapBackgroundOriginalCenter.y + translation.y)
            
            
            
        }else if sender.state == UIGestureRecognizerState.Ended{
            
            mapBackgroundOriginalCenter = mapBackground.center
            
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
