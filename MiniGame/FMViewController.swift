//
//  FlashMemoryViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-02.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit

class FMViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    var td: [String] = ["1","0","1","2",
                        "3","4","1","0",
                        "1","2","3","4",
                        "1","0","1","2"]
    
    let num: [Int] = [1,2,3,4,5,6,7,8,9,0]

    
    var itemOfRowNumber = 0
    //@IBOutlet weak var FMBoardCollectionView: UICollectionView!
    @IBOutlet weak var FMNumberCollectionView: UICollectionView!
    @IBOutlet weak var FMBoardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FMBoardCollectionView.delegate = self
        FMNumberCollectionView.delegate = self
        
        FMBoardCollectionView.dataSource = self
        FMNumberCollectionView.dataSource = self
        
        self.view.addSubview(FMBoardCollectionView)
        self.view.addSubview(FMNumberCollectionView)
        
        FMBoardCollectionView.layer.borderWidth = 1
        FMBoardCollectionView.layer.borderColor = UIColor.blackColor().CGColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == self.FMBoardCollectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FMBoardCell", forIndexPath: indexPath) as! FMCollectionViewCell
        
            let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        
            cell.layer.borderColor = bcolor.CGColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 3
            cell.backgroundColor=UIColor.whiteColor()
        
        print("get this")
            cell.lbNumber.text = td[indexPath.row]
        
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FMNumberCell", forIndexPath: indexPath) as! FMNumberCollectionViewCell
            
            let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
            
            cell.layer.borderColor = bcolor.CGColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 3
            cell.backgroundColor=UIColor.whiteColor()
            print("get here?")
            cell.lbNumber.text = "\(num[indexPath.row])"
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == FMBoardCollectionView {
            return td.count
        } else {
            return num.count
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == FMBoardCollectionView {
            let width = FMBoardCollectionView.bounds.size.width / 4
            return CGSizeMake(width, width)
        //return CGSize(width: collectionview.width, height: 100)
        } else {
            let width = (view.bounds.size.width - FMBoardCollectionView.bounds.size.width - 10) / 2
            return CGSizeMake(width, width)
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
