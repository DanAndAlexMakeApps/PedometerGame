//
//  InventoryViewController.swift
//  StepCounter
//
//  Created by Alex  Oser on 2/9/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var stepsToday: UILabel!
    @IBOutlet weak var stepsSinceDownload: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [item]?
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        self.stepsToday.text = "\(self.defaults.integerForKey("stepsTaken"))"
        self.stepsSinceDownload.text = "\(self.defaults.integerForKey("stepsSinceDownload"))"
        
        //for testing items
        let i1 = item(name: "test", description: "this is a test", picture: UIImage(named: "shield")!, xPos: 10, yPos: 10)
        items = [i1]
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let items = items{
            return items.count
        } else{
            return 0
        }
        
    }

    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("inventoryItem", forIndexPath:
            indexPath) as! inventoryItem
        let item = items![indexPath.row]
        cell.itemNameLabel.text = item.name
        cell.itemDescriptionLabel.text = item.descrip
        cell.itemImageView.image = item.picture
        
        return cell
    }

    
    
}
