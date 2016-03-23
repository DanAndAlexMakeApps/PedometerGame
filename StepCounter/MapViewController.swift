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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for view in mapBackgroundView.subviews{
            view.removeFromSuperview()
        }
        
        
        mapBackgroundView.setNeedsLayout()
        mapBackgroundView.layoutIfNeeded()
        
        var widthByCellCount = farthestXPos - farthestXNeg
        var heightByCellCount = farthestYPos - farthestYNeg
        
        if(widthByCellCount < 10){
            widthByCellCount = CGFloat(10)
        }
        if(heightByCellCount < 10){
            heightByCellCount = CGFloat(10)
        }
        
        mapBackgroundOriginalCenter = mapBackgroundView.center
        let mapWidth = mapBackgroundView.frame.size.width
        let mapHeight = mapBackgroundView.frame.size.height
        let mapCenterX = mapBackgroundView.center.x
        let mapCenterY = mapBackgroundView.center.y
        print("mapCenterX: \(mapCenterX)")
        print("mapCenterY: \(mapCenterY)")
        let mapCenter = mapBackgroundView.center
        let cellWidth = mapWidth / 10
        let cellHeight = mapHeight / 10
        
        mapBackgroundView.removeFromSuperview()
        
        print("height: \(heightByCellCount)")
        print("width: \(widthByCellCount)")
        
        let newMapBackground = UIView()
        newMapBackground.backgroundColor = UIColor.grayColor()
        newMapBackground.frame.size.height = heightByCellCount * cellHeight
        newMapBackground.frame.size.width = widthByCellCount * cellWidth
        newMapBackground.center = mapCenter
        
        self.view.addSubview(newMapBackground)
        
        
        for map in maps{
            
            
            
            let newView = UIView(frame: CGRectMake(0, 0, cellWidth, cellHeight))
            let xLoc = map.centerLocation[0] - curLocation[0]
            let yLoc = map.centerLocation[1] - curLocation[1]
            
            newView.center.x = mapCenterX + CGFloat(map.centerLocation[0] - curLocation[0]) / 2.0 * cellWidth
            newView.center.y = mapCenterY - CGFloat(map.centerLocation[1] - curLocation[1]) / 2.0 * cellHeight
            

            
            newMapBackground.addSubview(newView)
            newView.backgroundColor = map.view.backgroundColor
            
            
            
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
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func onMapPan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(mapBackgroundView)
        
        if sender.state == UIGestureRecognizerState.Began {
            

            
            
            
        } else if sender.state == UIGestureRecognizerState.Changed{
            
            mapBackgroundView.center = CGPoint(x: mapBackgroundOriginalCenter.x + translation.x, y: mapBackgroundOriginalCenter.y + translation.y)
            


            
        }else if sender.state == UIGestureRecognizerState.Ended{
            
            mapBackgroundOriginalCenter = mapBackgroundView.center
            
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
