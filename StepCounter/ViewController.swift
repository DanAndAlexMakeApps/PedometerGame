//
//  ViewController.swift
//  StepCounter
//
//  Created by Alex  Oser on 1/31/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    
    @IBOutlet weak var stairLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var controlBoardView: UIView!
    
    @IBOutlet weak var newPlayerImage: UIImageView!
    
    var items: [item]!
    var maps: [mapObject]!
    
    var center: CGPoint!
    
    // Initialize variables
    
    var days:[String] = []
    var stepsTaken: Int = 0
    var stepsUsed: Int = 0
    var stepsRemaining: Int = 0
    var stepsThisWeek: Int = 0
    var stepsSinceDownload: Int = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()

    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()

    var xOffset: Int = 0
    var yOffset: Int = 0
    var squaresMoved: Int = 0
    
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    
    var playerLoc = [0,0]
    var mapLoc = [0,0]
    
    var currentMap: mapObject!
    
    var mapHeight: CGFloat!
    var mapWidth: CGFloat!
    
    var playerImage: UIImageView!
    
    var farXPos: CGFloat!
    var farYPos: CGFloat!
    var farXNeg: CGFloat!
    var farYNeg: CGFloat!

    var itemsOwned: [item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        mapView.setNeedsLayout()
        mapView.layoutIfNeeded()
        
        newPlayerImage.layer.borderWidth = 1
        newPlayerImage.layer.borderColor = UIColor.blackColor().CGColor
        
        mapHeight = mapView.frame.size.height
        mapWidth = mapView.frame.size.width
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.backgroundColor = UIColor(red: 101/255, green: 247/255, blue: 159/255, alpha: 1.0)
        
        // Set date at which to access pedometer info later. Specifically, define the time of the last midnight.
        let cal = NSCalendar.currentCalendar()
        let comps = cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = NSTimeZone.systemTimeZone()
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.dateFromComponents(comps)!
        
        // If pedometer info is available, access it and store it to NSUserDefaults
        
        
        if(CMPedometer.isStepCountingAvailable()){
            let fromThisWeek = NSDate(timeIntervalSinceNow: -86400 * 7)
            let fromYesterday = NSDate(timeIntervalSinceNow: -86400)
            
            // Pedometer info since download
            
            if (NSDate() == midnightOfToday) {
            self.pedoMeter.queryPedometerDataFromDate(fromYesterday, toDate: NSDate()) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil){
                        
                        self.stepsSinceDownload += data!.numberOfSteps as Int
                        self.defaults.setInteger(self.stepsSinceDownload, forKey: "stepsSinceDownload")
                        
                    }
                })
                
            }
            }
            
            // Pedometer info this week
            
            self.pedoMeter.queryPedometerDataFromDate(fromThisWeek, toDate: NSDate()) { (data : CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil){
//                        self.weekLabel.text = "\(data!.numberOfSteps)"
                    }
                })
                
            }
            
            // Pedometer info today
            self.pedoMeter.startPedometerUpdatesFromDate(midnightOfToday) { (data: CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil){
                        self.stepsTaken = data!.numberOfSteps as Int
                        self.defaults.setInteger(self.stepsTaken, forKey: "stepsTaken")
                        self.stepsUsed = self.defaults.integerForKey("stepsUsed")
                        self.stepsLabel.text = "\(self.stepsTaken - self.stepsUsed)"
                        
                        if let floorsAscended = data?.floorsAscended {
                            self.stairLabel.text = "\(floorsAscended)"
                        }
                    }
                })
            }
            
        }
        
        

        
        
        cellWidth = mapView.bounds.size.width / CGFloat(22)
        cellHeight = mapView.bounds.size.height / CGFloat(22)
        center = self.mapView.center
        
        let playerImage = UIImageView(image: UIImage(named: "playerDown"))
        playerImage.bounds.size.height = cellHeight
        playerImage.bounds.size.width = cellWidth
        playerImage.layer.borderWidth = 1
        playerImage.layer.borderColor = UIColor.blackColor().CGColor
        
        //find current map from userdefauls--for now just creating from new
        self.mapView.removeFromSuperview()
        let newMap = mapObject(cLoc: [0, 0], view: UIView(frame: CGRectMake(0, 60, mapWidth, mapHeight)), cellWidth: self.cellWidth, cellHeight: self.cellHeight, center: center)
        newMap.view.backgroundColor = UIColor(red: 101/255, green: 247/255, blue: 159/255, alpha: 1.0)
        self.view.addSubview(newMap.view)
        self.view.sendSubviewToBack(newMap.view)
        currentMap = newMap
        items = currentMap.items
        
        //update from userdefaults/parse?
        maps = []
        maps.append(newMap)
        
        newPlayerImage.center = currentMap.center
        playerImage.center = currentMap.center
        
        self.view.addSubview(playerImage)
        
        newPlayerImage.removeFromSuperview()
        self.playerImage = playerImage
        self.view.sendSubviewToBack(controlBoardView)
        
        farXNeg = 0
        farXPos = 0
        farYNeg = 0
        farYPos = 0
    }

    
    // Function that is called every time the player moves
    
    func playerMoved() -> Bool {
        
        if (self.stepsTaken > self.stepsUsed+200) {
            self.stepsUsed += 200
            self.defaults.setInteger(self.stepsUsed, forKey: "stepsUsed")
            self.stepsRemaining = self.stepsTaken - self.stepsUsed
            self.stepsLabel.text = "\(self.stepsRemaining)"
            
            
            return true
        }
        else {
            return false
        }
        
        
    }
    
    func afterMove() {
        
        //print("x = \(playerLoc[0])")
        //print("y = \(playerLoc[1])")
    
        
        for item in items{
            if(item.absolutePosition[0] == playerLoc[0]){
                if(item.absolutePosition[1] == playerLoc[1]){
                    //print("FOUND")
                    item.found = true
                    item.itemView.removeFromSuperview()
                    itemsOwned.append(item)
                    if let inventoryView = self.tabBarController?.viewControllers![1] as? InventoryViewController{
                        inventoryView.items?.append(item)
                        inventoryView.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    func nextArea() {

        let x = CGFloat(self.xOffset)
        let y = CGFloat(self.yOffset)
        
        //check if map has already been discovered--
        //possibly sort maps or store better to make search faster?
        for map in maps{
            if(map.centerLocation == mapLoc){
                //map already exists: load map
                currentMap.view.removeFromSuperview()
                self.view.addSubview(map.view)
                self.view.sendSubviewToBack(map.view)
                map.view.center = center
                currentMap = map
                items = currentMap.items
                self.view.sendSubviewToBack(controlBoardView)
                
                return
            }
        }
        //map hasn't been found, create new map and load
        
        //fix dimensions of new view to work with autolayout
        let newMap = mapObject(cLoc: [mapLoc[0], mapLoc[1]], view: UIView(frame: CGRectMake(0, 60, mapWidth, mapHeight)), cellWidth: self.cellWidth, cellHeight: self.cellHeight, center: center)
        
        

        currentMap.view.removeFromSuperview()
        
        
        newMap.view.backgroundColor = UIColor(colorLiteralRed: Float(Float(arc4random()) / Float(UINT32_MAX)), green: Float(Float(arc4random()) / Float(UINT32_MAX)), blue: Float(Float(arc4random()) / Float(UINT32_MAX)), alpha: Float(Float(arc4random()) / Float(UINT32_MAX)))
        self.view.addSubview(newMap.view)
        self.view.sendSubviewToBack(newMap.view)
        self.view.sendSubviewToBack(controlBoardView)
        
        newMap.view.center = center
        
        currentMap = newMap
        maps.append(newMap)
        items = currentMap.items
        
        if(CGFloat(mapLoc[0]) > farXPos){
            farXPos = CGFloat(mapLoc[0])
        }
        if(CGFloat(mapLoc[0]) < farXNeg){
            farXNeg = CGFloat(mapLoc[0])
        }
        if(CGFloat(mapLoc[1]) > farYPos){
            farYPos = CGFloat(mapLoc[1])
        }
        if(CGFloat(mapLoc[1]) < farYNeg){
            farYNeg = CGFloat(mapLoc[1])
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // For testing purposes only
    
    @IBAction func addSteps(sender: UIButton) {
        self.stepsTaken += 5000
        self.stepsLabel.text = "\(self.stepsTaken)"
    }
    
    @IBAction func resetButton(sender: UIButton) {
        self.stepsUsed = 0
        self.stepsLabel.text = "\(self.stepsTaken)"
    }
    
    
    // On button tap, call playerMoved() which checks to see if player has enough steps and if so sets values
    // and then returns true. If true, move player and change playerSprite.
    
    @IBAction func moveLeftButton(sender: UIButton) {
        if (playerMoved()) {
            playerLoc[0] -= 1
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.playerImage.transform = CGAffineTransformTranslate(self.playerImage.transform, -self.cellWidth, 0)
            })
            
            playerImage.image = UIImage(named: "playerLeft")
            if (playerLoc[0] < (mapLoc[0] - 1) * 10) {
                mapLoc[0] -= 2
                self.xOffset = 325
                self.yOffset = 0
                nextArea()
                
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.playerImage.transform = CGAffineTransformTranslate(self.playerImage.transform, self.cellWidth * 20, 0)
                    
                })
            }
        }
        afterMove()
    }
    
    @IBAction func moveUpButton(sender: UIButton) {
        if (playerMoved()) {
            playerLoc[1] += 1

            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.playerImage.transform = CGAffineTransformTranslate(self.playerImage.transform, 0, -self.cellHeight)
            })

            playerImage.image = UIImage(named: "playerUp")
            if (playerLoc[1] > (mapLoc[1]+1)*10) {
                mapLoc[1] += 2
                
                self.xOffset = 0
                self.yOffset = 325
                nextArea()
            
                UIView.animateWithDuration(1, animations: { () -> Void in

                    self.playerImage.transform = CGAffineTransformTranslate(self.playerImage.transform, 0, self.cellHeight * 20)
                })
                
            }
        }
        afterMove()
    }
    
    @IBAction func moveDownButton(sender: UIButton) {
        if (playerMoved()) {
            playerLoc[1] -= 1

            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.playerImage.transform = CGAffineTransformTranslate(self.playerImage.transform, 0, self.cellHeight)
                
            })
            
            
            playerImage.image = UIImage(named: "playerDown")
            if (playerLoc[1] < (mapLoc[1]-1)*10) {
                mapLoc[1] -= 2
                
                self.xOffset = 0
                self.yOffset = -325
                nextArea()
                
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.playerImage.transform = CGAffineTransformTranslate(self.playerImage.transform, 0, -(self.cellHeight * 20))
                })
                
            }
        }
        afterMove()
    }
    
    @IBAction func moveRight(sender: UIButton) {
        if (playerMoved()) {
            playerLoc[0] += 1
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.playerImage.transform = CGAffineTransformTranslate(self.playerImage.transform, self.cellWidth, 0)
            })
            
            
            playerImage.image = UIImage(named: "playerRight")
            if (playerLoc[0] > (mapLoc[0]+1)*10) {
                mapLoc[0] += 2
                
                self.xOffset = -325
                self.yOffset = 0
                nextArea()
                
                
                UIView.animateWithDuration(1, animations: { () -> Void in

                    self.playerImage.transform = CGAffineTransformTranslate(self.playerImage.transform, -(self.cellWidth * 20), 0)
                })
                
            }
        }
        afterMove()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapViewController = segue.destinationViewController as? MapViewController {
            mapViewController.maps = maps
            mapViewController.curLocation = mapLoc
            
            mapViewController.farthestXNeg = farXNeg
            mapViewController.farthestXPos = farXPos
            mapViewController.farthestYNeg = farYNeg
            mapViewController.farthestYPos = farYPos
            
        }
    }
    

}