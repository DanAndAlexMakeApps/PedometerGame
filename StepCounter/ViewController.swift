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
    
    
    @IBOutlet weak var playerLocation: UIView!
    @IBOutlet weak var stairLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var playerSprite: UIImageView!
    @IBOutlet weak var mapView: UIView!
    
    var items: [item]!

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
            playerLocation.frame.origin.x -= 10
            playerSprite.image = UIImage(named: "playerLeft")
            if (playerLocation.frame.origin.x <= 0) {
                self.xOffset = 325
                self.yOffset = 0
                nextArea()
            }
        }
    }
    
    @IBAction func moveUpButton(sender: UIButton) {
        if (playerMoved()) {
            playerLocation.frame.origin.y -= 10
            playerSprite.image = UIImage(named: "playerUp")
            if (playerLocation.frame.origin.y <= 60) {
                self.xOffset = 0
                self.yOffset = 325
                nextArea()
            }
        }
    }
    
    @IBAction func moveDownButton(sender: UIButton) {
        if (playerMoved()) {
            playerLocation.frame.origin.y += 10
            playerSprite.image = UIImage(named: "playerDown")
            if (playerLocation.frame.origin.y + 50 >= 435) {
                self.xOffset = 0
                self.yOffset = -325
                nextArea()
            }
        }
    }
    
    @IBAction func moveRight(sender: UIButton) {
        if (playerMoved()) {
            playerLocation.frame.origin.x += 10
            playerSprite.image = UIImage(named: "playerRight")
            if (playerLocation.frame.origin.x + 50 >= 375) {
                self.xOffset = -325
                self.yOffset = 0
                nextArea()
            }
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        //for testing items
        
        let i1 = item(name: "testing1", description:  "testing1", picture: UIImage(named: "shield")!, xPos: 102, yPos: 103)
        let i2 = item(name: "testing2", description:  "testing2", picture: UIImage(named: "shield")!, xPos: 202, yPos: 203)
        
        items = [i1, i2]
        
        for item in items{
            print("item")
            if(!item.found){
                let itemView = UIImageView(image: item.picture)
                itemView.frame = CGRect(x: item.xPos, y: item.yPos, width: 10, height: 10)
            
                item.itemView = itemView
                view.addSubview(itemView)
            }
        }
        
    }

    
    // Function that is called every time the player moves
    
    func playerMoved() -> Bool {
        
        if (self.stepsTaken > self.stepsUsed+200) {
            self.stepsUsed += 200
            self.defaults.setInteger(self.stepsUsed, forKey: "stepsUsed")
            self.stepsRemaining = self.stepsTaken - self.stepsUsed
            self.stepsLabel.text = "\(self.stepsRemaining)"
            
            let playerLocX = (playerLocation.frame.origin.x)
            let playerLocY = (playerLocation.frame.origin.y)
            for item in items{
                let itemPosX = item.itemView.frame.origin.x
                let itemPosY = item.itemView.frame.origin.y
                print("item")
                print(itemPosX)
                print("player")
                print(playerLocX)
                if(itemPosX==playerLocX){
                    if(itemPosY==playerLocY){
                        item.found = true
                        item.itemView.removeFromSuperview()
                    }
                }
            }
            
            return true
        }
        else {
            return false
        }
        
        
    }
    
    func nextArea() {

        let x = CGFloat(self.xOffset)
        let y = CGFloat(self.yOffset)
        
        let mapFrame = CGRectOffset(mapView.frame, x, y)
        UIView.animateKeyframesWithDuration(2, delay: 0, options: .CalculationModeCubic, animations: {
                
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5) {
                self.mapView.frame = mapFrame
            }
                
            }, completion: nil)
        
        let playerFrame = CGRectOffset(playerLocation.frame, x, y)
        UIView.animateKeyframesWithDuration(2, delay: 0, options: .CalculationModeCubic, animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5) {
                self.playerLocation.frame = playerFrame
            }
            
            }, completion: nil)
        
        let newMapView = UIView(frame: CGRectMake(0, 60, 375, 375))
        newMapView.backgroundColor = UIColor(red: 101/255, green: 247/255, blue: 159/255, alpha: 1.0)
        self.view.insertSubview(newMapView, atIndex: 0)
        ++squaresMoved
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}