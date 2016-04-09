//
//  FlashMemoryViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-02.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit

class FMViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    var td: [String] = ["1","0","1","2","3","4","1","0","1","2","3","4","1","0","1","2","3","4","1","0","1","2","3","4"]
    var itemOfRowNumber = 0
    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionview.dataSource = self
        collectionview.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FMCell", forIndexPath: indexPath) as! FMCollectionViewCell
        
        let bcolor : UIColor = UIColor( red: 0.2, green: 0.2, blue:0.2, alpha: 0.3 )
        
        cell.layer.borderColor = bcolor.CGColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        cell.backgroundColor=UIColor.whiteColor()
        
        cell.lbNumber.text = td[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return td.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionview.bounds.size.width, collectionview.bounds.size.height)
        //return CGSize(width: collectionview.width, height: 100)
        
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
