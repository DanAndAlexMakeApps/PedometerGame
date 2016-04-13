//
//  InventoryViewController.swift
//  StepCounter
//
//  Created by Alex  Oser on 2/9/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var helmetImage: UIImageView!
    @IBOutlet weak var shoesImage: UIImageView!
    @IBOutlet weak var breastplateImage: UIImageView!
    @IBOutlet weak var pantsImage: UIImageView!
    
    
    
    @IBOutlet weak var personImage: UIImageView!
    
    var equipped: [item]! = []
    var items: [item]! = []
    
    var helmet: item?
    var shoes: item?
    var breastplate: item?
    var pants: item?
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        

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
        
        let tap = UITapGestureRecognizer(target: self, action: "didTap:")
        tap.delegate = self
        cell.addGestureRecognizer(tap)
        cell.tag = indexPath.row
        return cell
    }
    
    func didTap(gestureRecognizer: UITapGestureRecognizer){
        print("tapping")
        
        let cell = gestureRecognizer.view as! inventoryItem
        let index = cell.tag
        let selectedItem = items[index]
        items.removeAtIndex(index)
        let type = selectedItem.type
        if(type == 0){
            if let curShoe = helmet{
                items.append(curShoe)
            }
            
            helmet = selectedItem
            helmetImage.image = selectedItem.picture
            
            
            
        }else if(type == 1){
            
            if let curShoe = shoes{
                items.append(curShoe)
            }
            
            shoes = selectedItem
            shoesImage.image = selectedItem.picture
            
            
            
        }else if(type == 2){
            
            if let curShoe = breastplate{
                items.append(curShoe)
            }
            
            breastplate = selectedItem
            breastplateImage.image = selectedItem.picture
            
        }else if(type == 3){
            if let curShoe = pants{
                items.append(curShoe)
            }
            
            pants = selectedItem
            pantsImage.image = selectedItem.picture
            
            
        }else{
            print("error type too high")
        }
        


        collectionView.reloadData()
        
    }
    
    @IBAction func onTapHelmet(sender: UITapGestureRecognizer) {
        if let helmet = helmet{
            items.append(helmet)
        }
        helmetImage.image = nil
        helmet = nil
        
        collectionView.reloadData()
        
    }
    
    @IBAction func onTapShoes(sender: UITapGestureRecognizer) {
        if let shoes = shoes{
            items.append(shoes)
        }
        shoesImage.image = nil
        shoes = nil
        collectionView.reloadData()
    }
    
    @IBAction func onTapBreast(sender: UITapGestureRecognizer) {
        if let breastplate = breastplate{
            items.append(breastplate)
        }
        breastplateImage.image = nil
        breastplate = nil
        collectionView.reloadData()
    }
    
    @IBAction func onTapPants(sender: UITapGestureRecognizer) {
        if let pants = pants{
            items.append(pants)
        }
        pantsImage.image = nil
        pants = nil
        collectionView.reloadData()
    }
    
    

}
