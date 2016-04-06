//
//  ListViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-02.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit
import CoreMotion

class GameListViewController: UIViewController {

    let manager = CMMotionManager()
    
    //@IBOutlet weak var lbShow: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background_1.jpg")!)
        
        //print(manager.deviceMotionAvailable)
        
        manager.gyroUpdateInterval = 1
        manager.startGyroUpdates()
        //let queue = NSOperationQueue.mainQueue
        /*
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { [weak self] (data: CMDeviceMotion?, error: NSError?) in
                
                let rotation = atan2(data!.gravity.x, data!.gravity.y) - M_PI
                self!.imgView.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
            }
        }
 
 */
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
