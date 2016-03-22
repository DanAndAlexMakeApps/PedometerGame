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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for view in mapBackgroundView.subviews{
            view.removeFromSuperview()
        }
        
        mapBackgroundView.setNeedsLayout()
        mapBackgroundView.layoutIfNeeded()
        
        let mapWidth = mapBackgroundView.frame.size.width
        let mapHeight = mapBackgroundView.frame.size.height
        let mapCenterX = mapBackgroundView.center.x
        let mapCenterY = mapBackgroundView.center.y
        print("mapCenterX: \(mapCenterX)")
        print("mapCenterY: \(mapCenterY)")
        let mapCenter = mapBackgroundView.center
        let cellWidth = mapWidth / 10
        let cellHeight = mapHeight / 10
        
        
        
        for map in maps{
            
            let newView = UIView(frame: CGRectMake(0, 0, cellWidth, cellHeight))
            self.mapBackgroundView.addSubview(newView)
            newView.backgroundColor = map.view.backgroundColor
            newView.center.x = mapCenterX + CGFloat(map.centerLocation[0]) / 2.0 * cellWidth
            newView.center.y = mapCenterY - CGFloat(map.centerLocation[1]) / 2.0 * cellHeight
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
