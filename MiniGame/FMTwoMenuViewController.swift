//
//  FMTwoMenuViewController.swift
//  MiniGame
//
//  Created by Elaine Jin on 2016-04-09.
//  Copyright © 2016 Elaine Jin. All rights reserved.
//

import UIKit

class FMTwoMenuViewController: UIViewController {

    var gridnum = 2.0
    var gapnum = 1.0
    //@IBOutlet weak var gridNumber: UITextField!
    //@IBOutlet weak var flashingGap: UITextField!
    @IBOutlet weak var gridNumber: UITextField!
    @IBOutlet weak var flashingGap: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridNumber.userInteractionEnabled = false
        flashingGap.userInteractionEnabled = false
        
        gridNumber.text! = "\(gridnum)"
        flashingGap.text! = "\(gapnum)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: button action
    @IBAction func backToList(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func gridMinus(sender: UIButton) {
        if Double(gridNumber.text!) > 2.0 {
            gridnum -= 1.0
            gridNumber.text = "\(gridnum)"
        }
    }
    
    @IBAction func gridPlus(sender: UIButton) {
        if Double(gridNumber.text!) < 9.0 {
            gridnum += 1.0
            gridNumber.text = "\(gridnum)"
        }
    }
    
    @IBAction func gapMinus(sender: UIButton) {
        if Double(flashingGap.text!) > 0.0 {
            gapnum -= 1.0
            flashingGap.text = "\(gapnum)"
        }
    }
    
    @IBAction func gapPlus(sender: UIButton) {
        if Double(flashingGap.text!) < 2.0 {
            gapnum += 1.0
            flashingGap.text = "\(gapnum)"
        }
    }
    
    
    
    @IBAction func unwindToMenuList(sender: UIStoryboardSegue) {
        if sender.identifier == "backtoMenu" {
            print("back from the FMTwo game view")
            let sourceViewController = sender.sourceViewController as? FMTwoViewController
            sourceViewController?.timer.invalidate()
        }
        if let sourceViewController = sender.sourceViewController as? FMTwoViewController {
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playFMTwo" {
            
             let game: FMTwoViewController = segue.destinationViewController as! FMTwoViewController
             //game.questions = self.questions
             game.colNumber = gridnum
             game.rowNumber = gridnum
             game.gap = gapnum
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
